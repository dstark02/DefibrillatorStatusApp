//
//  BluetoothManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth
import RealmSwift

class BluetoothManager: NSObject, BluetoothManagerProtocol, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: Properties
    var centralManager : CBCentralManager?
    var currentPeripheral : CBPeripheral?
    var defibrillatorList: [CBPeripheral]
    var eventList: [String]
    var delegate : BluetoothManagerDelegate?
    var bluetoothState : BluetoothState {
        didSet {
            delegate?.bluetoothStateHasChanged(bluetoothState: bluetoothState)
        }
    }
    var characteristicDelegate : BluetoothCharacteristicDelegate?
    var characteristicState : CharacteristicState {
        didSet {
            characteristicDelegate?.characteristicStateHasChanged(characteristicState: characteristicState)
        }
    }
    
    // MARK: Initialiser
    
    override init() {
        bluetoothState = .Started
        characteristicState = .NotFound
        defibrillatorList = [CBPeripheral]()
        eventList = [String]()
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    //MARK: Central Methods
    
    func scanForDefibrillators() {
        
        if (bluetoothState != .Off) {
            centralManager?.scanForPeripherals(withServices: [BluetoothConstants.serviceUUID], options: nil)
            bluetoothState = .Scanning
            print("scanning")
            _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(CBCentralManager.stopScan), userInfo: nil, repeats: false)
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        print(peripheral.name ?? "Defib")
        defibrillatorList.append(peripheral)
        bluetoothState = .FoundDefibrillator
        print("Found")
    }
    
    func stopScan() {
        centralManager?.stopScan()
        bluetoothState = .Stopped
    }
    
    func connectToDefibrillator(peripheral : CBPeripheral) {
        peripheral.delegate = self
        centralManager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        currentPeripheral = peripheral
        currentPeripheral?.delegate = self
        bluetoothState = .ConnectedToDefibrillator
        print("Connected to Defib")
        discoverDefibrillatorServices()
    }

    // MARK: CBCentral required method
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case.poweredOn:
            bluetoothState = .Started
            print("Bluetooth is on")
        case.poweredOff:
            bluetoothState = .Off
            print("Turn Bluetooth on")
        case.unauthorized:
            bluetoothState = .Off
            print("Unautorized")
        case.resetting:
            print("resetting")
        case.unknown:
            print("unknown")
        case.unsupported:
            bluetoothState = .Off
            print("Unsupported")
            
        }
    }
    
}
