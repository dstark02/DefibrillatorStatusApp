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
        currentPeripheral?.discoverServices([BluetoothConstants.serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered Service")
        
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            characteristicState = .Searching
            peripheral.discoverCharacteristics([BluetoothConstants.passwordCharacteristicUUID], for: service)
            peripheral.discoverCharacteristics([BluetoothConstants.eventListCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        // empty
    }
    
    func downloadEvent(peripheral: CBPeripheral, date: String) {
        self.date = date
        guard let peripheralServices = peripheral.services else { return }
        
        for service in peripheralServices {
            peripheral.discoverCharacteristics([BluetoothConstants.ecgDataCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered Characteristic")
        characteristicState = .Found
        

        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.uuid == BluetoothConstants.passwordCharacteristicUUID {
                peripheral.readValue(for: characteristic)
            }
            
            if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
                peripheral.readValue(for: characteristic)
            }
            
            if characteristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if characteristic.uuid == BluetoothConstants.passwordCharacteristicUUID {
            guard let dataReceived = characteristic.value else { return }
            guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
            scanDelegate?.passwordReceived(password: dataAsString)
        }
        
        if characteristic.uuid == BluetoothConstants.eventListCharacteristicUUID {
            formatStringToDisplay(characteristic: characteristic)
        }
        
        if characteristic.uuid == BluetoothConstants.ecgDataCharacteristicUUID {
            if (fileLength != 0) {
                readECGData(characteristic: characteristic, periperhral: peripheral)
            } else {
                guard let dataReceived = characteristic.value else { return }
                guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
                guard let length = Float(dataAsString) else { return }
                fileLength = length
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
        //print(downloadProgress)
        
        if (downloadProgress > 0.998) {
            periperhral.setNotifyValue(false, for: characteristic)
            centralManager?.cancelPeripheralConnection(periperhral)
            event.date = date
            downloadComplete = AccessDatabase.writeEvent(event: event)
        }
    }

}
