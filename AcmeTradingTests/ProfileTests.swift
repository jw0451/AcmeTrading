//
//  ProfileTests.swift
//  AcmeTradingTests
//
//  Created by John Wilson on 27/10/2020.
//

import XCTest
@testable import AcmeTrading

class ProfileTests: XCTestCase {
    
    // Imagine these are set up like in LoginTests
    func testSuccessfulProfileList() throws {
    }
    
    func testUnauthorisedProfileList() throws {
    }

    func testProfileListData() throws {
        let jsonString = """
         {"data": {"user_message": "Successfully loaded profiles", "profiles": [{"name": "Eric Cantona", "star_level": 3, "distance_from_user": "0.2m", "num_ratings": 39, "enabled": true, "profile_image": "https://www.pngkit.com/png/full/508-5084521_download-female-profile-icon-png-clipart-computer-icons.png"}, {"name": "Eric Djemba-Djemba", "star_level": 2, "distance_from_user": "0.6m", "num_ratings": 32, "enabled": true, "profile_image": "https://storage.googleapis.com/stateless-campfire-pictures/2019/04/6f56fc81-dummyuserimage-1556273962c8p4l.jpg"}, {"name": "Roger T. Rabbit", "star_level": 2, "distance_from_user": "1.3m", "num_ratings": 2, "enabled": true, "profile_image": "https://storage.googleapis.com/stateless-campfire-pictures/2019/04/6f56fc81-dummyuserimage-1556273962c8p4l.jpg"}, {"name": "Arthur C. Doyle", "star_level": 1, "distance_from_user": "9.3m", "num_ratings": 48, "enabled": false, "profile_image": "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRbKfsUgF_NCHY4foakfygi76_kJfsXkXRvfg&usqp=CAU"}, {"name": "Bob Builder", "star_level": 1, "distance_from_user": "10.6m", "num_ratings": 18, "enabled": false, "profile_image": "https://storage.googleapis.com/stateless-campfire-pictures/2019/04/6f56fc81-dummyuserimage-1556273962c8p4l.jpg"}, {"name": "Jessica Rabbit", "star_level": 2, "distance_from_user": "6.5m", "num_ratings": 9, "enabled": false, "profile_image": "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRbKfsUgF_NCHY4foakfygi76_kJfsXkXRvfg&usqp=CAU"}]}, "meta": {"status_code": 200, "reason": "Successfully loaded profiles"}}
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        let profileResponse = APIService().parseProfileListJSON(json: jsonData)
        XCTAssertNotNil(profileResponse, "profile list response should decode correctly")
    }}
