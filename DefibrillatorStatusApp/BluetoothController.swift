//
//  ViewController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 16/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothController: UIViewController, CBCentralManagerDelegate {
    
    // MARK: Properties
    var centralManager: CBCentralManager!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case.poweredOn:
            print("Bluetooth is on")
            //self.centralManager.scanForPeripherals(withServices: <#T##[CBUUID]?#>, options: <#T##[String : Any]?#>)
        case.poweredOff:
            print("Turn Bluetooth on")
        case.unauthorized:
            print("Unautorized")
        case.resetting:
            print("resetting")
        case.unknown:
            print("unknown")
        case.unsupported:
            print("Unsupported")
        
        }
    }
    
    


}

