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
    }
    
    //MARK: Bluetooth Methods
    
    func getBluetoothState() -> BluetoothState {
        return bluetoothState
    }
    
    func scanForDefibrillators() {
        centralManager?.scanForPeripherals(withServices: [BluetoothConstants.serviceUUID], options: nil)
        bluetoothState = .Scanning
        print("scanning")
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(CBCentralManager.stopScan), userInfo: nil, repeats: false)
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
        bluetoothState = .ConnectedToDefibrillator
        print("Connected to Defib")
        peripheral.discoverServices([BluetoothConstants.serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("Discovered Service")
        for service in peripheral.services! {
            let thisService = service as CBService
            characteristicState = .Searching
            peripheral.discoverCharacteristics([BluetoothConstants.characteristicUUID], for: thisService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("discovered characteristic")
        characteristicState = .Found
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            // check for data characteristic
            peripheral.readValue(for: thisCharacteristic)
            //peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                //peripheral.readValueForCharacteristic(thisCharacteristic);
        }
        
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    
        print("updated value")
        if let dataReceived = characteristic.value {
            
            if let dataString = String(data: dataReceived, encoding: .utf8) {
                let stringFormatted = dataString.components(separatedBy: ",")
                print(dataString)
                
                print(stringFormatted.count)
                
                for i in 0 ..< stringFormatted.count {
                    eventList.append(stringFormatted[i])
                }
                characteristicState = .Updated
                
            }
            //peripheral.setNotifyValue(false, forCharacteristic: characteristic)
        }
    }




    // MARK: CBCentral required method


    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
     //   switch central.state {
       // case.poweredOn:
         //   print("Bluetooth is on")
       // case.poweredOff:
       //     print("Turn Bluetooth on")
       // case.unauthorized:
         //   print("Unautorized")
       // case.resetting:
         //   print("resetting")
        //case.unknown:
        //    print("unknown")
        //case.unsupported:
          //  print("Unsupported")
            
       // }
    //}
    
}
