//
//  DefibrillatorStatusAppUITests.swift
//  DefibrillatorStatusAppUITests
//
//  Created by David Stark on 16/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import XCTest

class DefibrillatorStatusAppUITests: XCTestCase {
        
    var app : XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoginNavigation() {
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("testuser")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        app.buttons["Log In"].tap()
        
        XCTAssert(app.navigationBars["Find Defibrillator"].staticTexts["Find Defibrillator"].exists)
    }
    
    
    func testLoginFailsAndUserIsAlerted() {
        // no username, only password entered
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("invalidpassword")
        app.otherElements.containing(.staticText, identifier:"AED STATUS").element.tap()
        
        app.buttons["Log In"].tap()
        
        XCTAssert(app.alerts["Login failed"].staticTexts["Login failed"].exists)
    }
    
    func testBluetoothIsOffAndUserIsAlerted() {
        testLoginNavigation()
        app.switches["0"].tap()        
        XCTAssert(app.alerts["Bluetooth"].exists)
    }
    
    
    func testSavedEventControllerExists() {
        testLoginNavigation()
        app.tabBars.buttons["Saved Events"].tap()
        XCTAssert(app.navigationBars["Saved Events"].staticTexts["Saved Events"].exists)
    }
    
    func testChartControllerExists() {
        testSavedEventControllerExists()
        let staticText = app.tables.staticTexts["01/Nov/2016 13:00"]
        staticText.tap()
        
        let ecgTraceButton = app.buttons["ECG Trace"]
        XCTAssert(ecgTraceButton.exists)
        let eventInfoButton = app.buttons["Event Information"]
        XCTAssert(eventInfoButton.exists)
    }
    
    func testChartControllerBackNavigation() {
        testChartControllerExists()
        
        app.navigationBars["DefibrillatorStatusApp.Segmented"].buttons["Saved Events"].tap()
        XCTAssert(app.navigationBars["Saved Events"].staticTexts["Saved Events"].exists)
    }
    
    func testEventInformationExists() {
        testChartControllerExists()
        
        app.buttons["Event Information"].tap()
        
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.staticTexts["Event Time"].exists)
        XCTAssert(tablesQuery.staticTexts["Duration"].exists)
        XCTAssert(tablesQuery.staticTexts["Number of Shocks"].exists)
        XCTAssert(tablesQuery.staticTexts["Event Information"].exists)
        XCTAssert(tablesQuery.staticTexts["Event Log"].exists)
        XCTAssert(tablesQuery.staticTexts["Patient Information"].exists)
    }
    
    func testPatientControllerExists() {
        
        testEventInformationExists()
        
        app.tables.staticTexts["Patient Information"].tap()
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.staticTexts["Name"].exists)
        XCTAssert(tablesQuery.staticTexts["Gender"].exists)
        XCTAssert(tablesQuery.staticTexts["D.O.B"].exists)
    }
    
    func testPatientBackNavigation() {
        
        testPatientControllerExists()
        
        let backButton = app.navigationBars["DefibrillatorStatusApp.PatientDetails"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0)
        backButton.tap()
        let tablesQuery = app.tables
        XCTAssert(tablesQuery.staticTexts["Event Information"].exists)
    }
    
    func testEventLogNavigation() {
        testEventInformationExists()
        app.tables.staticTexts["Event Log"].tap()
        XCTAssert(app.tables.staticTexts["Event Log"].exists)
    }
    
    func testEventLogBackNavigation() {
        testEventLogNavigation()
       
        app.navigationBars["DefibrillatorStatusApp.EventLog"].children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
        XCTAssert(app.tables.staticTexts["Event Information"].exists)
        
    }
    
}
