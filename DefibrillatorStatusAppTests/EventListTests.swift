//
//  EventListTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class EventListTests: XCTestCase {
    
    var bluetoothManager : BluetoothManager!
    var eventListControllerMock: EventListControllerMock!
    
    override func setUp() {
        super.setUp()
        bluetoothManager = BluetoothManager()
        eventListControllerMock = EventListControllerMock()
        eventListControllerMock.bluetoothManager = bluetoothManager
        bluetoothManager.characteristicDelegate = eventListControllerMock
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class EventListControllerMock : EventListController {
        
        var characteristicState : CharacteristicState?
        
        override func characteristicStateHasChanged(characteristicState: CharacteristicState) {
            self.characteristicState = characteristicState
        }
    }
    
    func testCharacteristicStateDelegateForNotFoundCalled() {
        bluetoothManager.characteristicState = .NotFound
        XCTAssertEqual(bluetoothManager.characteristicState, eventListControllerMock.characteristicState)
    }
    
    func testCharacteristicStateDelegateForSearchingCalled() {
        bluetoothManager.characteristicState = .Searching
        XCTAssertEqual(bluetoothManager.characteristicState, eventListControllerMock.characteristicState)
    }
    
    func testCharacteristicStateDelegateForFoundCalled() {
        bluetoothManager.characteristicState = .Found
        XCTAssertEqual(bluetoothManager.characteristicState, eventListControllerMock.characteristicState)
    }
    
    func testCharacteristicStateDelegateForUpdatedCalled() {
        bluetoothManager.characteristicState = .Updated
        XCTAssertEqual(bluetoothManager.characteristicState, eventListControllerMock.characteristicState)
    }
    
}
