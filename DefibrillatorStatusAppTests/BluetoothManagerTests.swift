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
    }
    
    override func tearDown() {
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
