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
    
    func testControllerTitleExists() {
        XCTAssert(app.navigationBars["Find Defibrillator"].exists)
    }
    
    func testScanLabelHasntAppeared() {
        let scanLabel = app.staticTexts["SCANNING"]
        XCTAssertFalse(scanLabel.exists)
    }
    
    func testFinishScanLabelHasntAppeared() {
        let finishedLabel = app.staticTexts["FINISHED SCAN, RETRY IF NO DEVICES LISTED"]
        XCTAssertFalse(finishedLabel.exists)
    }
    
    func testScanningLabelAppears() {
        app.switches["0"].tap()
        XCTAssert(app.staticTexts["SCANNING"].exists)
    }
    
    func testFinishScanLabelAppears() {
        app.switches["0"].tap()
        app.switches["1"].tap()
        XCTAssert(app.staticTexts["FINISHED SCAN, RETRY IF NO DEVICES LISTED"].exists)
    }
    
    func testScanLabelDisappears() {
        let scanLabel = app.staticTexts["SCANNING"]
        app.switches["0"].tap()
        app.switches["1"].tap()
        XCTAssertFalse(scanLabel.exists)
    }
    
    
}
