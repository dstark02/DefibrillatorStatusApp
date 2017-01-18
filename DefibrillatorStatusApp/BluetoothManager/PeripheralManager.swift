//
//  PeripheralManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import RealmSwift
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
        for characteristic in service.characteristics! {
            if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
                //let thisCharacteristic = charateristic as CBCharacteristic
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            if characteristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
                
                
                peripheral.readValue(for: characteristic)
                
                
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
            formatStringToDisplay(characteristic: characteristic)
        }
        
        if characteristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
            if (fileLength != 0) {
                readECGData(characteristic: characteristic, periperhral: peripheral)
            } else {
                if let dataReceived = characteristic.value {
                    
                    if let dataAsString = String(data: dataReceived, encoding: .utf8) {
                        
                        if let length = UInt16(dataAsString) {
                            fileLength = Float(length)
                            peripheral.setNotifyValue(true, for: characteristic)
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK : Helper Methods
    
    func formatStringToDisplay(characteristic: CBCharacteristic) {
        
        if let dataReceived = characteristic.value {
            
            if let dataAsString = String(data: dataReceived, encoding: .utf8) {
                
                let dataFormatted = dataAsString.components(separatedBy: ",")
                
                for i in 0 ..< dataFormatted.count {
                    eventList.append(dataFormatted[i])
                }
                characteristicState = .Updated
            }
        }
    }
    
    func readECGData(characteristic : CBCharacteristic, periperhral : CBPeripheral) {
        
        if let dataReceived = characteristic.value {
            
            let ecg = ECG()
            ecg.ecg = dataReceived
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(ecg)
                    print("value wrote")
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
        
        downloadValue += 1/fileLength
        
        if (downloadValue > 0.998) {
            periperhral.setNotifyValue(false, for: characteristic)
        }
    }
    
    

    
}
