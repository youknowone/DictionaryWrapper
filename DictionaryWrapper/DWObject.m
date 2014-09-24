//
//  DWObject.m
//  DictionaryWrapper
//
//  Created by Jeong YunWon on 2014. 8. 20..
//  Copyright (c) 2014년 youknowone.org. All rights reserved.
//

#import "DWObject.h"
#import <objc/runtime.h>


id DWGeneralCacheToKey(id self, id<NSCopying> cacheKey, DWCacheMapper operator) {
    id obj = objc_getAssociatedObject(self, (__bridge void *)cacheKey);
    if (obj == nil) {
        obj = operator(self);
        objc_setAssociatedObject(self, (__bridge void *)cacheKey, obj, OBJC_ASSOCIATION_RETAIN);
    }
    return obj;
}

id DWPropertyCacheToKey(DWObject *self, id<NSCopying> key, id<NSCopying> cacheKey, DWCacheMapper operator) {
    return DWGeneralCacheToKey(self, cacheKey, ^id (DWObject *self) {
        id raw = self[key];
        return operator(raw);
    });
}

id DWPropertyCache(DWObject *self, id<NSCopying> key, DWCacheMapper operator) {
    return DWPropertyCacheToKey(self, key, key, operator);
}



@implementation DWObject

@synthesize _object=_object;

- (instancetype)initWithSafeDataObject:(id)object {
    self = [super init];
    if (self != nil) {
        self->_object = object;
    }
    return self;
}

- (instancetype)initWithDataObject:(id)object {
    if (object == nil) {
        @throw NSInvalidArgumentException;
    }
    return [self initWithSafeDataObject:object];
}

+ (instancetype)objectWithDataObject:(id)object {
    return [[self alloc] initWithDataObject:object];
}

+ (instancetype):(id)object {
    return [self objectWithDataObject:object];
}

- (instancetype)initWithJSONData:(NSData *)data error:(NSError *__autoreleasing *)error {
    id dataObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (error != nil) {
        return nil;
    }
    return [self initWithDataObject:dataObject];
}

+ (instancetype)objectWithJSONData:(NSData *)data error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithJSONData:data error:error];
}

- (instancetype)initWithJSONString:(NSString *)string error:(NSError *__autoreleasing *)error {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding]; // This is safe! JSON string is expected to be escaped anyway.
    return [self initWithJSONData:data error:error];
}

+ (instancetype)objectWithJSONString:(NSString *)string error:(NSError *__autoreleasing *)error {
    return [[self alloc] initWithJSONString:string error:error];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSDictionary *dictionary = [[NSDictionary alloc] initWithCoder:aDecoder];
    return [self initWithDataObject:dictionary];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self->_object encodeWithCoder:aCoder];
}

- (NSDictionary *)_dictionary {
    return self->_object;
}

- (id)objectForKeyedSubscript:(id)key {
    return self->_object[key];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    static NSMethodSignature *getterSignature = nil;

    id signature = [super methodSignatureForSelector:aSelector];
    if (signature) {
        return signature;
    }

    if (getterSignature == nil) {
        getterSignature = [self methodSignatureForSelector:@selector(_object)];
    }

    if ([NSStringFromSelector(aSelector) rangeOfString:@":"].location == NSNotFound) {
        signature = getterSignature;
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *selName = NSStringFromSelector(anInvocation.selector);
    if ([selName rangeOfString:@":"].location == NSNotFound) {
        id value = self->_object[selName];
        [anInvocation setReturnValue:&value];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: '%@'>", @(class_getName(self.class)), self._object];
}

+ (NSArray *)objectsWithDataObjects:(NSArray *)array {
    NSMutableArray *objects = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id dataObject, NSUInteger idx, BOOL *stop) {
        [objects addObject:[[self alloc] initWithSafeDataObject:dataObject]];
    }];
    return [objects copy]; // immutable copy
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] :[self->_object copy]];
}

- (BOOL)isEqual:(id)object {
    return [self class] == [object class] && [self._object isEqual:((DWObject *)object)._object];
}

// it is abnormal so this class is not declared as NSMutableCopying, but use it if you trust the object allows mutable copy.
- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] :[self->_object mutableCopy]];
}

@end


@implementation DWNotNullObject

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *selName = NSStringFromSelector(anInvocation.selector);
    if ([selName rangeOfString:@":"].location == NSNotFound) {
        id value = self._object[selName];
        if (value == [NSNull null]) value = nil;
        [anInvocation setReturnValue:&value];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (id)objectForKeyedSubscript:(id)key {
    id object = [super objectForKeyedSubscript:key];
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

@end
