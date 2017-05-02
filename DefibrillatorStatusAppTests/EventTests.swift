//
//  EventTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        CurrentEventProvider.duration = nil
        super.tearDown()
    }
    
    func testEventDuration() {
        CurrentEventProvider.duration = 300 // seconds
        XCTAssertEqual("05 mins 00 secs", TimeCalculator.getEventDuration())
    }
    
    func testDurationLessThanMinute() {
        CurrentEventProvider.duration = 59
        XCTAssertEqual("59 secs", TimeCalculator.getEventDuration())
    }
    
    func testDurationNotSet() {
        XCTAssertEqual("", TimeCalculator.getEventDuration())
    }
    
    
}
