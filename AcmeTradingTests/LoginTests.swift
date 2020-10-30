//
//  LoginTests.swift
//  AcmeTradingTests
//
//  Created by John Wilson on 27/10/2020.
//

import XCTest
@testable import AcmeTrading

class LoginTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessfulLogin() throws {
        let session = MockURLSession()
        let apiService = APIService(session: session)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLoginData() throws {
        let jsonString = """
        {
            "data": {
                "user_message": "Successfully logged in",
                "auth_token": "eyJhbGciOiJIUzI1NiIsInR5cGUiOiJKV1QiLCJ0b2tlbl90eXBlIjoiYWNjZXNzIn0.eyJzdWIiOiIxMjM0N TY3ODkwIiwibmFtZSI6IlVzZXIgTW9ycGhldXMiLCJpYXQiOjE1MTYyMzkwMjIsImV4cGlyZXMiOiIxNTE2MjM 5MDIyIn0.FiSWp-i8rG-LO-pJSYg27a5IF23LI_WecJkJ8mqPob8",
                "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cGUiOiJKV1QiLCJ0b2tlbl90eXBlIjoicmVmcmVzaCJ9.eyJzdWIiOiIxMjM0 NTY3ODkwIiwibmFtZSI6IlVzZXIgTW9ycGhldXMiLCJpYXQiOjE1MTYyMzkwMjIsImV4cGlyZXMiOiIxNTE2OT k5MDIyIn0.8ZUYINyNq5J38DF785neJzbRe6-lpBg7AQuoeAmuzEo"
            },
            "meta": {
                "status_code": 200,
                "reason": "ok"
            }
        }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail()
            return
        }
        let loginResponse = APIService().parseLoginJSON(json: jsonData)
        XCTAssertNotNil(loginResponse, "login response should decode correctly")
    }
}
