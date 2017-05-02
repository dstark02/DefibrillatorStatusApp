//
//  BluetoothScanTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class BluetoothScanTests: XCTestCase {
    
    
    var bluetoothManager: BluetoothManager!
    var scanControllerMock: ScanControllerMock!
    
    override func setUp() {
        super.setUp()
        bluetoothManager = BluetoothManager()
        scanControllerMock = ScanControllerMock()
        scanControllerMock.bluetoothManager = bluetoothManager
        bluetoothManager.scanDelegate = scanControllerMock
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    class ScanControllerMock : ScanController {
        
        var bluetoothState: BluetoothState?
        
        override func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
            self.bluetoothState = bluetoothState
        }
    }
    
    func testBluetoothStateDelegateForStartedCalled() {
        bluetoothManager.bluetoothState = .Started
        XCTAssertEqual(bluetoothManager.bluetoothState, scanControllerMock.bluetoothState)
    }
    
    func testBluetoothStateDelegateForScanningCalled() {
        bluetoothManager.bluetoothState = .Scanning
        XCTAssertEqual(bluetoothManager.bluetoothState, scanControllerMock.bluetoothState)
    }
    
    func testBluetoothStateDelegateForStoppedCalled() {
        bluetoothManager.bluetoothState = .Stopped
        XCTAssertEqual(bluetoothManager.bluetoothState, scanControllerMock.bluetoothState)
    }
    
    func testBluetoothStateDelegateForFoundDefibrillatorCalled() {
        bluetoothManager.bluetoothState = .FoundDefibrillator
        XCTAssertEqual(bluetoothManager.bluetoothState, scanControllerMock.bluetoothState)
    }
    
    func testBluetoothStateDelegateForConnectedCalled() {
        bluetoothManager.bluetoothState = .ConnectedToDefibrillator
        XCTAssertEqual(bluetoothManager.bluetoothState, scanControllerMock.bluetoothState)
    }
    
    func testDownloadProgressDelegateCalled() {
        let bluetoothManager = BluetoothManager()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scanController = storyboard.instantiateViewController(withIdentifier: "ScanController") as! ScanController
        
        scanController.bluetoothManager = bluetoothManager
        scanController.loadView()
        scanController.viewDidLoad()
        scanController.progressView.progress = 0
        
        bluetoothManager.scanProgress = 0.5
        
        XCTAssertEqual(bluetoothManager.downloadProgress, scanController.progressView.progress)
    }
    
    
    
    
    
    
}
