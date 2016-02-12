@mainpage DictionaryWrapper

This toolkit suggests an easy way to create wrapper classes for objects which supports keyed subscript interface.
It is especially useful for JSON handling.

NOTE: This toolkit is working with subclassing. Read docs below first.

CocoaPods available.

# How to

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



To read about initializers,

@see DWObject
