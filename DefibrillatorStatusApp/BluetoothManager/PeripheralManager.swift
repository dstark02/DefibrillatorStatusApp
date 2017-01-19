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
        currentPeripheral?.discoverServices([BluetoothConstants.serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered Service")
        for service in peripheral.services! {
            characteristicState = .Searching
            peripheral.discoverCharacteristics([BluetoothConstants.eventListCharacteristicUUID], for: service)
        }
    }
    
    func downloadEvent(peripheral: CBPeripheral) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([BluetoothConstants.ecgDataCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Discovered Characteristic")
        characteristicState = .Found
        
        for characteristic in service.characteristics! {
            if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
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
                for item in dataFormatted {
                    eventList.append(item)
                }
                characteristicState = .Updated
            }
        }
    }
    
    func readECGData(characteristic : CBCharacteristic, periperhral : CBPeripheral) {
        
        if let dataReceived = characteristic.value {
            let ecg = ECG()
            ecg.ecg = dataReceived
            event.ecgs.append(ecg)
            downloadValue += 1/fileLength
            print(downloadValue)
        }
        
        if (downloadValue > 0.998) {
            periperhral.setNotifyValue(false, for: characteristic)
            writeToDatabase()
        }
    }
    
    func writeToDatabase() {

        event.date = "18/Jan/2017"
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(event)
                print("value wrote")
                downloadComplete = true
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
