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
        
        
        downloadController.bluetoothManager.downloadDelegate = downloadController.self
        downloadController.loadView()
        downloadController.viewDidLoad()
        
        bluetoothManager.downloadProgress = 0.5
        
        XCTAssertEqual(bluetoothManager.downloadProgress, downloadController.progressView.progress)
    }
    
//    func testDownloadCompleteDelegateCalled() {
//        let bluetoothManager = BluetoothManager()
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let downloadController = storyboard.instantiateViewController(withIdentifier: "DownloadEventController") as! DownloadEventController
//        
//        downloadController.bluetoothManager = bluetoothManager
//        
//        
//        downloadController.bluetoothManager.downloadDelegate = downloadController.self
//        downloadController.loadView()
//        downloadController.viewDidLoad()
//        
//        bluetoothManager.downloadComplete = true
//        
//        XCTAssertNotNil(downloadController.)
//    }
    
    
    
}
