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
    
    func downloadEvent(peripheral: CBPeripheral, date: String) {
        self.date = date
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
                guard let dataReceived = characteristic.value else { return }
                guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
                guard let length = UInt16(dataAsString) else { return }
                fileLength = Float(length)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    
    // MARK : Helper Methods
    
    func formatStringToDisplay(characteristic: CBCharacteristic) {
        guard let dataReceived = characteristic.value else { return }
        guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
                
        let dataFormatted = dataAsString.components(separatedBy: ",")
        for item in dataFormatted {
            eventList.append(item)
        }
        characteristicState = .Updated
    }
    
    func readECGData(characteristic : CBCharacteristic, periperhral : CBPeripheral) {
        guard let dataReceived = characteristic.value else { return }
        let ecg = ECG(ecg: dataReceived)
        event.ecgs.append(ecg)
        downloadProgress += 1/fileLength
        
        if (downloadProgress > 0.998) {
            periperhral.setNotifyValue(false, for: characteristic)
            centralManager?.cancelPeripheralConnection(periperhral)
            event.date = date
            downloadComplete = AccessDatabase.writeEvent(event: event)
        }
    }

}
