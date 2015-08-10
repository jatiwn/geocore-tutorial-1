//
//  GeocoreKitTests.swift
//  GeocoreKitTests
//
//  Created by Purbo Mohamad on 4/14/15.
//
//

import UIKit
import XCTest
import GeocoreKit
import PromiseKit

private let GEOCORE_BASEURL = "http://put.geocore.api.server.url.here"
private let GEOCORE_PROJECTID = "#PUT_PROJECT_ID_HERE#"
private let GEOCORE_USERID = "#PUT_USER_ID_HERE#"
private let GEOCORE_USERPASSWORD = "#PUT_USER_PASSWORD_HERE#"

private let PLACE_TEST_1_ID = "PLA-TEST-1-SWIFTTEST-1"
private let PLACE_TEST_1_NAME = "Test Swift 1"
private let PLACE_TEST_1_PT = GeocorePoint(latitude: 35.65858, longitude: 139.745433)

class GeocoreKitTests: XCTestCase {
    
    override class func setUp() {
        Geocore.sharedInstance.setup(GEOCORE_BASEURL, projectId: GEOCORE_PROJECTID)
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Security
    
    func testA1_loginFailure() {
        let expectation = expectationWithDescription("Login failure expectation")
        
        let _:() = Geocore.sharedInstance
            .login("dummy_userid", password: "dummy_password")
            .catch { (error) -> Void in
                XCTAssert(error.code == GeocoreError.SERVER_ERROR.rawValue)
                if let serverCode = error.userInfo?["code"] as? String {
                    XCTAssert(serverCode == "Auth.0001")
                } else {
                    XCTFail("Unexpected server error: \(error)")
                }
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for failed login = \(error)")
        })
    }
    
    func testA2_loginSuccessful() {
        let expectation = expectationWithDescription("Login successful expectation")
        
        let _:() = Geocore.sharedInstance
            .login(GEOCORE_USERID, password: GEOCORE_USERPASSWORD)
            .then { (accessToken: String) -> Void in
                println("Access Token = \(accessToken)")
                XCTAssert(count(accessToken) > 0)
                expectation.fulfill()
            }
            .catch { (error) -> Void in
                XCTFail("Error logging in: \(error)")
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for successful login = \(error)")
        })
    }
    
    // MARK: - Object
    
    func testB1_getObject() {
        let expectation = expectationWithDescription("Get single object expectation")
        
        let _:() = GeocoreObject.get(GEOCORE_USERID)
            .then { (object: GeocoreObject) -> Void in
                XCTAssertEqual(object.id!, GEOCORE_USERID)
                expectation.fulfill()
            }
            .catch { (error) -> Void in
                XCTFail("Error getting object: \(error)")
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for single object = \(error)")
        })
    }
    
    // MARK: - Place
    
    func testC1_createPlace() {
        let expectation = expectationWithDescription("Create place expectation")
        
        let tags = ["駅", "テゴリー1", "カテゴリー2"]
        
        let place = GeocorePlace()
        place.id = PLACE_TEST_1_ID
        place.name = PLACE_TEST_1_NAME
        place.point = PLACE_TEST_1_PT
        place.tag(tags)
        let _:() = place.save()
            .then { (place: GeocorePlace) -> Void in
                XCTAssertEqual(place.id!, PLACE_TEST_1_ID)
                XCTAssertEqual(place.name!, PLACE_TEST_1_NAME)
                for tag in place.tags! {
                    if find(tags, tag.name!) == nil {
                        XCTFail("Unexpected tag: \(tag.name!)")
                    }
                }
                expectation.fulfill()
            }
            .catch { (error) -> Void in
                XCTFail("Error creating place: \(error)")
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for place creation = \(error)")
        })
    }
    
    func testC2_getAndUpdatePlace() {
        let expectation = expectationWithDescription("Update place expectation")
        
        let newName = "Test Swift 2"
        
        let _:() = GeocorePlace.get(PLACE_TEST_1_ID)
            .then { (place: GeocorePlace) -> Promise<GeocorePlace> in
                place.name = newName
                return place.save()
            }
            .then { (place: GeocorePlace) -> Void in
                XCTAssertEqual(place.id!, PLACE_TEST_1_ID)
                XCTAssertEqual(place.name!, newName)
                expectation.fulfill()
            }
            .catch { (error) -> Void in
                XCTFail("Error creating place: \(error)")
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for place update = \(error)")
        })
    }
    
    func testC3_deletePlace() {
        let expectation = expectationWithDescription("Delete place expectation")
        
        let _:() = GeocorePlace.get(PLACE_TEST_1_ID)
            .then { (place: GeocorePlace) -> Promise<GeocorePlace> in
                XCTAssertEqual(place.id!, PLACE_TEST_1_ID)
                return place.delete()
            }
            .then { (place: GeocorePlace) -> Void in
                XCTAssertEqual(place.id!, PLACE_TEST_1_ID)
                expectation.fulfill()
            }
            .catch { (error) -> Void in
                XCTFail("Error deleting place: \(error)")
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for place delete = \(error)")
        })
    }
    
    func testC3_deletePlaceConfirm() {
        let expectation = expectationWithDescription("Delete place confirm expectation")
        
        let _:() = GeocorePlace.get(PLACE_TEST_1_ID)
            .then { (place: GeocorePlace) -> Void in
                XCTFail("Deleted place found, shouldn't happen")
            }
            .catch { (error) -> Void in
                XCTAssert(error.code == GeocoreError.SERVER_ERROR.rawValue)
                if let serverCode = error.userInfo?["code"] as? String {
                    XCTAssert(serverCode == "General.0011")
                } else {
                    XCTFail("Unexpected server error: \(error)")
                }
                expectation.fulfill()
            }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error) -> Void in
            println("Error waiting for place delete confirmation = \(error)")
        })
    }
    
}
