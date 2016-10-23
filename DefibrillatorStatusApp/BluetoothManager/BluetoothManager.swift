//
//  BluetoothManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, BluetoothManagerProtocol, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: Properties
    
    var centralManager : CBCentralManager?
    let defibrillatorServiceUUID = CBUUID(string: "12ab")
    var defibrillatorList: [String]
    var delegate : BluetoothManagerDelegate?
    var bluetoothState : BluetoothState {
        didSet {
            delegate?.bluetoothStateHasChanged(bluetoothState: bluetoothState)
        }
    }
    
    // MARK: Initialiser
    
    override init() {
        bluetoothState = BluetoothState.Started
        defibrillatorList = [String]()
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //MARK: Bluetooth Methods
    
    func getBluetoothState() -> BluetoothState {
        return bluetoothState
    }
    
    func scanForDefibrillators() {
        centralManager?.scanForPeripherals(withServices: [defibrillatorServiceUUID], options: nil)
        bluetoothState = .Scanning
        print("scanning")
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        print(peripheral.name)
        defibrillatorList.append(peripheral.name!)
        bluetoothState = .FoundDefibrillator
        // centralManager?.connect(peripheral, options: nil)
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
