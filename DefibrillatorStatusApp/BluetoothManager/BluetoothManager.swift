//
//  BluetoothManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate,
CBPeripheralDelegate {
    
    // MARK: Properties
    
    var bluetoothState : BluetoothState!
    var centralManager : CBCentralManager?
    var defibrillator  : CBPeripheral?
    let defibrillatorServiceUUID = CBUUID(string: "12ab")
    
    // TODO: Create Peripheral services UUID variable here
    
    override init() {
        bluetoothState = BluetoothState.Started
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func getBluetoothState() -> BluetoothState {
        return bluetoothState
    }
    
    func scanForDefibrillators() {
        centralManager?.scanForPeripherals(withServices: [defibrillatorServiceUUID], options: nil)
        bluetoothState = .Scanning
    }
    
    
    // MARK: CBCentral required method
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case.poweredOn:
            scanForDefibrillators()
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
