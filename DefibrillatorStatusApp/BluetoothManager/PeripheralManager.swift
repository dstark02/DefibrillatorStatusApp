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
            peripheral.discoverCharacteristics([BluetoothConstants.characteristicUUID], for: thisService)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        print("Discovered Characteristic")
        characteristicState = .Found
        
        // check the uuid of each characteristic to find config and data characteristics
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            peripheral.readValue(for: thisCharacteristic)
            peripheral.setNotifyValue(true, for: thisCharacteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?){
        
        print("updated value")
        formatStringToDisplay(characteristic: characteristic)
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
