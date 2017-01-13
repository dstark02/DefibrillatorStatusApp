//
//  PeripheralManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth

extension BluetoothManager {
    
    // MARK : Peripheral Methods
    
    
    
    func discoverDefibrillatorServices() {
        currentPeripheral?.delegate = self
        currentPeripheral?.discoverServices([BluetoothConstants.serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("Discovered Service")
        for service in peripheral.services! {
            let thisService = service as CBService
            characteristicState = .Searching
            peripheral.discoverCharacteristics([BluetoothConstants.eventListCharacteristicUUID, BluetoothConstants.ecgDataCharacteristicUUID], for: thisService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Discovered Characteristic")
        characteristicState = .Found
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            if charateristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
                //let thisCharacteristic = charateristic as CBCharacteristic
                peripheral.readValue(for: charateristic)
                peripheral.setNotifyValue(true, for: charateristic)
            }
            
            if charateristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
                
                peripheral.setNotifyValue(true, for: charateristic)
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?){
        
        // print("updated value")
        if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
            formatStringToDisplay(characteristic: characteristic)
        }
        
        if characteristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
            
            if let dataReceived = characteristic.value {
                
                var value = UInt32(0)
                var index = 0
                var length = 0
                
                while (index < dataReceived.count - 4) {
                    
                    count += dataReceived.count
                    length = dataReceived.count - 4
                    print(length)
                    print("NOTE")
                    
                    (dataReceived as NSData).getBytes(&value, range: NSMakeRange(index, 4))
                    value = UInt32(bigEndian: value)
                    print(value)
                    index += 4
                }
                
                if (count >= 59648) {
                    print("Notify set")
                    peripheral.setNotifyValue(false, for: characteristic)
                }
                
            }
        }
    }
    
    
    
    
    
    
    // MARK : Helper Method
    
    func formatStringToDisplay(characteristic: CBCharacteristic) {
        
        if let dataReceived = characteristic.value {
            
            if let dataString = String(data: dataReceived, encoding: .utf8) {
                
                let stringFormatted = dataString.components(separatedBy: ",")
                
                print(dataString)
                
                for i in 0 ..< stringFormatted.count {
                    eventList.append(stringFormatted[i])
                }
                characteristicState = .Updated
            }
            //peripheral.setNotifyValue(false, forCharacteristic: characteristic)
        }
    }
    
    

    
}
