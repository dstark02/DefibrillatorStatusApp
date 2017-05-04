//
//  CurrentEventTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 03/05/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class CurrentEventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testCurrentEventHasBeenSet() {
        let event = Event()
        event.date = "01/Mar/2017"
        CurrentEventProvider.currentEvent = event
        
        XCTAssertEqual(event, CurrentEventProvider.currentEvent!)
    }
    
    func testCurrentEventDurationHasBeenSet() {
        CurrentEventProvider.duration = 500
        
        XCTAssertEqual(500, CurrentEventProvider.duration!)
    }
    
    func testCurrentEventMarkersHaveBeenSet() {
        var markers = [Marker]()
        markers.append(Marker(markerCode: 2, markerValue: 0, markerSample: 1))
        
        CurrentEventProvider.markers = markers
        
        XCTAssertEqual(markers.first!.markerCode, CurrentEventProvider.markers!.first!.markerCode)
        
    }
    
    
}
