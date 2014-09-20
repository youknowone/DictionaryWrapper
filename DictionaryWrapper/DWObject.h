//
//  DWObject.h
//  DictionaryWrapper
//
//  Created by Jeong YunWon on 2014. 8. 20..
//  Copyright (c) 2014년 youknowone.org. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief DWObject is a wrapper generation interface for keyed subscript object,
 *      which is NSDictionary-like. This interface is not designed to be used by
 *      itself. See the examples in the below or the test file.
 */
@interface DWObject: NSObject<NSCopying, NSCoding>

/*!
 *  @brief Keyed subscript object which is used or generated in initialization phase.
 */
@property(readonly) id _object;
/*!
 *  @brief Refers @ref dataObject but as NSDictionary interface for convinience.
 */
@property(readonly) NSDictionary *_dictionary;

/*!
 *  @brief Returns an initialized DWObject object containing given data object.
 *  @param object An object which satisfies keyed subscript interface.
 *  @throw NSInvalidArgumentException
 */
- (instancetype)initWithDataObject:(id)object;
/*!
 *  @brief Returns a DWObject object containing given data object.
 *  @param object An object which satisfies keyed subscript interface.
 *  @throw NSInvalidArgumentException
 *  @see initWithDataObject:
 */
+ (instancetype)objectWithDataObject:(id)object;
/*!
 *  @brief Returns a DWObject object containing given data object.
 *  @param object An object which satisfies keyed subscript interface.
 *  @throw NSInvalidArgumentException
 *  @details
 *      This method is convinient wrapper of @ref objectWithDataObject:
 *
 *          id dataObject = // your data object
 *          DWObject *object = [DWObject :dataObject];
 *
 *  @see initWithDataObject:
 */
+ (instancetype):(id)object;

/*!
 *  @brief Returns an initialized DWObject object containing the content of given JSON data.
 *  @param data The data object representing JSON content.
 *  @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 *  @throw NSInvalidArgumentException
 *  @details error is used to
 */
- (instancetype)initWithJSONData:(NSData *)data error:(NSError **)error;
/*!
 *  @brief Returns a DWObject object containing the content of given JSON data.
 *  @param data The data object representing JSON content.
 *  @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 *  @throw NSInvalidArgumentException
 *  @see objectWithJSONData:
 */
+ (instancetype)objectWithJSONData:(NSData *)data error:(NSError **)error;

/*!
 *  @brief Returns an initialized DWObject object containing the content of given JSON string.
 *  @param string The string object representing JSON content.
 *  @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 *  @throw NSInvalidArgumentException
 */
- (instancetype)initWithJSONString:(NSString *)string error:(NSError **)error;
/*!
 *  @brief Returns a DWObject object containing the content of given JSON string.
 *  @param string The string object representing JSON content.
 *  @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 *  @throw NSInvalidArgumentException
 *  @see objectWithJSONString:
 */
+ (instancetype)objectWithJSONString:(NSString *)string error:(NSError **)error;

/*!
 *  @brief Returns an array of objects containing the data objects of given array.
 *  @param objects An array for the data objects to transform to wrapped object.
 */
+ (NSArray *)objectsWithDataObjects:(NSArray *)objects;

@end


/*!
 *  @brief DWNotNullObject transforms NSNull to nil for getter.
 */
@interface DWNotNullObject: DWObject

@end
