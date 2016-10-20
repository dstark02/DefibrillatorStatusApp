//
//  BluetoothManagerTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class BluetoothManagerTests: XCTestCase {
    
    var bluetoothManager: BluetoothManager!
    
    override func setUp() {
        bluetoothManager = BluetoothManager()
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBluetoothState() {
        XCTAssertEqual(BluetoothState.Started, bluetoothManager.getBluetoothState())
    }
    
    func testScanForDefibrillator() {
        bluetoothManager.scanForDefibrillators()
        XCTAssertEqual(BluetoothState.Scanning, bluetoothManager.getBluetoothState())
    }
}

