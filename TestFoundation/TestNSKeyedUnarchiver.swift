// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


#if DEPLOYMENT_RUNTIME_OBJC || os(Linux)
    import Foundation
    import XCTest
#else
    import SwiftFoundation
    import SwiftXCTest
#endif


class TestNSKeyedUnarchiver : XCTestCase {
    static var allTests: [(String, (TestNSKeyedUnarchiver) -> () throws -> Void)] {
        return [
            ("test_unarchive_array", test_unarchive_array),
            ("test_unarchive_complex", test_unarchive_complex),
            ("test_unarchive_concrete_value", test_unarchive_concrete_value),
            // ("test_unarchive_notification", test_unarchive_notification), // does not yet support isEqual()
            ("test_unarchive_nsedgeinsets_value", test_unarchive_nsedgeinsets_value),
            ("test_unarchive_nsrange_value", test_unarchive_nsrange_value),
            ("test_unarchive_nsrect", test_unarchive_nsrect_value),
            ("test_unarchive_ordered_set", test_unarchive_ordered_set),
            ("test_unarchive_url", test_unarchive_url),
            ("test_unarchive_uuid", test_unarchive_uuid),
        ]
    }
    
    private func test_unarchive_from_file(_ filename : String, _ expectedObject : NSObject) {
        guard let testFilePath = testBundle().pathForResource(filename, ofType: "plist") else {
            XCTFail("Could not find \(filename)")
            return
        }
        let object = NSKeyedUnarchiver.unarchiveObjectWithFile(testFilePath) as? NSObject
        if expectedObject != object {
            print("\(expectedObject) != \(object)")
        }
        XCTAssertEqual(expectedObject, object)
    }

    func test_unarchive_array() {
        let array = ["baa", "baa", "black", "sheep"]
        test_unarchive_from_file("NSKeyedUnarchiver-ArrayTest", array.bridge())
    }
    
    func test_unarchive_complex() {
        let uuid = NSUUID(UUIDString: "71DC068E-3420-45FF-919E-3A267D55EC22")!
        let url = URL(string: "index.xml", relativeTo: URL(string: "https://www.swift.org"))!
        let array = NSArray(array: [ NSNull(), NSString(string: "hello"), NSNumber(value: 34545), ["key" : "val"].bridge() ])
        let dict : Dictionary<String, NSObject> = [
            "uuid" : uuid,
            "url" : url.bridge(),
            "string" : "hello".bridge(),
            "array" : array
        ]
        test_unarchive_from_file("NSKeyedUnarchiver-ComplexTest", dict.bridge())
    }
    
    func test_unarchive_concrete_value() {
        let array: Array<Int32> = [1, 2, 3]
        let objctype = "[3i]"
        array.withUnsafeBufferPointer { cArray in
            let concrete = NSValue(bytes: cArray.baseAddress!, objCType: objctype)
            test_unarchive_from_file("NSKeyedUnarchiver-ConcreteValueTest", concrete)
        }
    }

//    func test_unarchive_notification() {
//        let notification = Notification(name: Notification.Name(rawValue:"notification-name"), object: "notification-object".bridge(),
//                                          userInfo: ["notification-key": "notification-val"])
//        test_unarchive_from_file("NSKeyedUnarchiver-NotificationTest", notification)
//    }
    
    func test_unarchive_nsedgeinsets_value() {
        let edgeinsets = NSEdgeInsets(top: CGFloat(1.0), left: CGFloat(2.0), bottom: CGFloat(3.0), right: CGFloat(4.0))
        test_unarchive_from_file("NSKeyedUnarchiver-EdgeInsetsTest", NSValue(edgeInsets: edgeinsets))
    }
    
    func test_unarchive_nsrange_value() {
        let range = NSMakeRange(97345, 98345)
        test_unarchive_from_file("NSKeyedUnarchiver-RangeTest", NSValue(range: range))
    }
    
    func test_unarchive_nsrect_value() {
        let origin = NSPoint(x: CGFloat(400.0), y: CGFloat(300.0))
        let size = NSSize(width: CGFloat(200.0), height: CGFloat(300.0))
        let rect = NSRect(origin: origin, size: size)
        test_unarchive_from_file("NSKeyedUnarchiver-RectTest", NSValue(rect: rect))
    }
    
    func test_unarchive_ordered_set() {
        let set = NSOrderedSet(array: ["valgeir".bridge(), "nico".bridge(), "puzzle".bridge()])
        test_unarchive_from_file("NSKeyedUnarchiver-OrderedSetTest", set)
    }
    
    func test_unarchive_url() {
        let url = URL(string: "foo.xml", relativeTo: URL(string: "https://www.example.com"))
        test_unarchive_from_file("NSKeyedUnarchiver-URLTest", url!.bridge())
    }
    
    func test_unarchive_uuid() {
        let uuid = NSUUID(UUIDString: "0AD863BA-7584-40CF-8896-BD87B3280C34")
        test_unarchive_from_file("NSKeyedUnarchiver-UUIDTest", uuid!)
    }
}
