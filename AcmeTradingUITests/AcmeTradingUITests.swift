//
//  AcmeTradingUITests.swift
//  AcmeTradingUITests
//
//  Created by John Wilson on 27/10/2020.
//

import XCTest

class AcmeTradingUITests: XCTestCase {

    func testExample() throws {
        
        let app = XCUIApplication()

        app.launch()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let usernamefieldTextField = elementsQuery/*@START_MENU_TOKEN@*/.textFields["usernameField"]/*[[".textFields[\"E.g. Gary123\"]",".textFields[\"usernameField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        usernamefieldTextField.tap()
        usernamefieldTextField.typeText("user@morpheustest.com")
        
        let passwordTextField = app.secureTextFields["password"]
        passwordTextField.tap()
        passwordTextField.typeText("Password1")

        elementsQuery.buttons["LOG IN"].tap()

        app.collectionViews.otherElements.containing(.button, identifier:"Menu").children(matching: .button).matching(identifier: "Menu").element(boundBy: 1).tap()

                app.sheets.scrollViews.otherElements.buttons["Log out"].tap()
    }
}
