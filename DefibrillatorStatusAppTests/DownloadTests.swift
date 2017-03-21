//
//  BluetoothManagerTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import XCTest
@testable import DefibrillatorStatusApp

class DownloadTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testDownloadProgressDelegateCalled() {
        let bluetoothManager = BluetoothManager()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let downloadController = storyboard.instantiateViewController(withIdentifier: "DownloadEventController") as! DownloadEventController
        
        downloadController.bluetoothManager = bluetoothManager
        downloadController.loadView()
        downloadController.viewDidLoad()
        
        bluetoothManager.downloadProgress = 0.5
        
        XCTAssertEqual(bluetoothManager.downloadProgress, downloadController.progressView.progress)
    }
    
    func testDownloadCompleteDelegateCalled() {

        class DownloadEventControllerMock : DownloadEventController {
            
            var functionCalled = false
        
            override func downloadComplete(event: Event) {
                functionCalled = true
            }
        }
        
        let bluetoothManager = BluetoothManager()
        let mockDownloadEventController = DownloadEventControllerMock()
        mockDownloadEventController.bluetoothManager = bluetoothManager
        mockDownloadEventController.bluetoothManager.downloadDelegate = mockDownloadEventController.self
        bluetoothManager.downloadComplete = true
        
        XCTAssertTrue(mockDownloadEventController.functionCalled)
    }
    
    
    
}
