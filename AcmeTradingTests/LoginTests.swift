//
//  LoginTests.swift
//  AcmeTradingTests
//
//  Created by John Wilson on 27/10/2020.
//

import XCTest
@testable import AcmeTrading

class LoginTests: XCTestCase {
    let testResponseJson = """
    {
        "data": {
            "user_message": "Successfully logged in",
            "auth_token": "tokenWithAuthority",
            "refresh_token": "tokenThatIsRefreshing"
        },
        "meta": {
            "status_code": 200,
            "reason": "ok"
        }
    }
    """
    
    let unauthorisedResponseJson = """
    {
        "data": {
            "user_message": "Incorrect username/password combination"
        },
        "meta": {
            "status_code": 401,
            "reason": "ok"
        }
    }
    """
    
    let failedResponseJson = """
    {
        "data": {
            "user_message": "Something randomly went wrong"
        },
        "meta": {
            "status_code": 500,
            "reason": "Something randomly went wrong"
        }
    }
    """
    
    
    func testSuccessfulLogin() throws {
        guard let jsonData = testResponseJson.data(using: .utf8), let url = URL(string: APIService.loginURLString) else {
            XCTFail()
            return
        }

        let username = "test"
        let password = "pass"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, jsonData, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let apiService = APIService(session: mockSession)
        
        let expectation = self.expectation(description: "Logging in")
        
        apiService.login(username: username, password: password) { (loginResponse, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(loginResponse)
            XCTAssert(loginResponse?.data.authToken == "tokenWithAuthority")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUnauthorisedLogin() throws {
        guard let jsonData = unauthorisedResponseJson.data(using: .utf8), let url = URL(string: APIService.loginURLString) else {
            XCTFail()
            return
        }

        let username = "test"
        let password = "pass"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, jsonData, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let apiService = APIService(session: mockSession)
        
        let expectation = self.expectation(description: "Logging in")
        
        apiService.login(username: username, password: password) { (loginResponse, error) in
            XCTAssertNotNil(error)
            XCTAssert(loginResponse?.meta.statusCode == 401)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFailedLogin() throws {
        guard let jsonData = failedResponseJson.data(using: .utf8), let url = URL(string: APIService.loginURLString) else {
            XCTFail()
            return
        }

        let username = "test"
        let password = "pass"
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        URLProtocolMock.mockURLs = [url: (nil, jsonData, response)]

        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)

        let apiService = APIService(session: mockSession)
        
        let expectation = self.expectation(description: "Logging in")
        
        apiService.login(username: username, password: password) { (loginResponse, error) in
            XCTAssertNotNil(error)
            XCTAssert(loginResponse?.meta.statusCode == 500)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testLoginData() throws {
        
        guard let jsonData = testResponseJson.data(using: .utf8) else {
            XCTFail()
            return
        }
        let loginResponse = APIService().parseLoginJSON(json: jsonData)
        XCTAssertNotNil(loginResponse, "login response should decode correctly")
    }
}
