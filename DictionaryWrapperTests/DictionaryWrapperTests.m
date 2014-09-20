//
//  DictionaryWrapperTests.m
//  DictionaryWrapperTests
//
//  Created by Jeong YunWon on 2014. 9. 20..
//  Copyright (c) 2014년 youknowone.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import <DictionaryWrapper/DictionaryWrapper.h>

//! Header

/*!
 *  Subclass @ref DWObject to make your own interface for your dictionaries.
 */
@interface DWTest: DWObject

/*!
 *  Declare properties to access. Tip: readonly is automatically supported.
 */
@property(readonly) NSString *type;
@property(readonly) NSString *value;
@property(readonly) NSNumber *number;
@property(readonly) NSNull *null;

@end

//! Body

@implementation DWTest

/*!
 *  you need @dynamic to prevent auto-synthesizing
 */
@dynamic type, value, number, null;

@end


//! Header

/*!
 *  DWNotNullObject is same to DWObject, except for the NSNull handling.
 *  Use it for your preferences.
 */
@interface DWSafeTest : DWNotNullObject

/*!
 *  Declare properties to access. Tip: readonly is automatically supported.
 */
@property(readonly) NSString *type;
@property(readonly) NSString *value;
@property(readonly) NSNumber *number;
@property(readonly) NSNull *null;

@end

//! Body

@implementation DWSafeTest

/*!
 *  you need @dynamic to prevent auto-synthesizing
 */
@dynamic type, value, number, null;

@end



//! Usage
void test(id self) {
    // preparing JSON data and object
    NSData *JSONData = [@"{\"type\": \"test\", \"value\": \"wrapped value\", \"number\": 42, \"null\": null}" dataUsingEncoding:NSUTF8StringEncoding];
    id dataObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:NULL];

    DWTest *testObject = [DWTest :dataObject]; // convinient method to create DWObject

    XCTAssertEqualObjects(testObject.type, @"test", @"`type` property is connected to the field in JSON data");
    XCTAssertEqualObjects(testObject.value, @"wrapped value", @"`value` property is also connected");
    XCTAssertEqualObjects(testObject.number, @(42), @"`number` is type of NSNumber");
    XCTAssertEqualObjects(testObject.null, [NSNull null], @"null is type of NSNull");

    DWSafeTest *safeObject = [DWSafeTest :dataObject]; // almost same
    XCTAssertNil(safeObject.null, @"but `null` is nil");

    NSArray *dataObjects = @[dataObject, dataObject, dataObject];
    NSArray *multipleObjects = [DWTest objectsWithDataObjects:dataObjects];
    XCTAssertEqual(multipleObjects.count, dataObjects.count, @"conut is the same");
    for (id object in multipleObjects) {
        XCTAssertEqualObjects([object class], [DWTest class], @"classes are the same");
    }
    XCTAssertEqualObjects(multipleObjects[0], multipleObjects[1], @"if data are the same, wrappers also are the same.");
}



@interface DictionaryWrapperTests : XCTestCase

@end

@implementation DictionaryWrapperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    test(self);
}

- (void)testCreation {
    // This is an example of a functional test case.
    id dataObject = @{@"id": @1, @"value": @"my value"};
    DWObject *wrapped = [DWObject :dataObject];
    XCTAssertEqualObjects(wrapped._object[@"id"], @(1));
    XCTAssertEqualObjects(wrapped._object[@"value"], @"my value");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
