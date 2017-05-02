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
    
    
    /// Discover services from connected Defibrillator
    func discoverDefibrillatorServices() {
        currentPeripheral?.discoverServices([BluetoothConstants.serviceUUID])
    }
    
    /// Invoked when discovered the defibrillator's available services
    ///
    /// - Parameters:
    ///   - peripheral: defibrillator
    ///   - error: If an error occurred, the cause of the failure
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered Service")
        
        guard let peripheralServices = peripheral.services else { return }
        for service in peripheralServices {
            characteristicState = .Searching
            peripheral.discoverCharacteristics([BluetoothConstants.passwordCharacteristicUUID, BluetoothConstants.eventListCharacteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        // empty
    }
    
    /// Initiates an event download from the connected defibrillator
    ///
    /// - Parameters:
    ///   - peripheral: defibrillator
    ///   - date: date of event
    func downloadEvent(peripheral: CBPeripheral, date: String) {
        self.date = date
        guard let peripheralServices = peripheral.services else { return }
        
        for service in peripheralServices {
            peripheral.discoverCharacteristics([BluetoothConstants.ecgDataCharacteristicUUID], for: service)
        }
    }
    
    /// Invoked when discovered the characteristics of specified service
    ///
    /// - Parameters:
    ///   - peripheral: defibrillator
    ///   - service: The service that the characteristics belong to
    ///   - error: If an error occurred, the cause of the failure
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
    
    /// Invoked when a specified characteristic’s value has been retrieved
    ///
    /// - Parameters:
    ///   - peripheral: defibrillator
    ///   - characteristic: The characteristic the value belongs to
    ///   - error: If an error occurred, the cause of the failure
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if characteristic.uuid == BluetoothConstants.passwordCharacteristicUUID {
            guard let dataReceived = characteristic.value else { return }
            guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
            if date == nil {
                scanDelegate?.passwordReceived(password: dataAsString)
            }
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
    
    /// Creates a String array from data received for the event list
    /// - Parameter characteristic: value returned from defibrillator
    func formatStringToDisplay(characteristic: CBCharacteristic) {
        guard let dataReceived = characteristic.value else { return }
        guard let dataAsString = String(data: dataReceived, encoding: .utf8) else { return }
                
        let dataFormatted = dataAsString.components(separatedBy: ",")
        for item in dataFormatted {
            eventList.append(item)
        }
        characteristicState = .Updated
    }
    
    
    /// Takes event data received from defibrillator and appends it to ECG array
    /// Updates download progress and will write event to database on completion
    /// - Parameters:
    ///   - characteristic: value returned from defibrillator
    ///   - periperhral: connected defibrillator
    func readECGData(characteristic : CBCharacteristic, periperhral : CBPeripheral) {
        guard let dataReceived = characteristic.value else { return }
        let ecg = ECG(ecg: dataReceived)
        event.ecgs.append(ecg)
        // update variable for progress bar
        downloadProgress += 1/fileLength
        
        if (downloadProgress > 0.998) {
            periperhral.setNotifyValue(false, for: characteristic)
            // finished with peripheral
            centralManager?.cancelPeripheralConnection(periperhral)
            if let eventDate = date {
                event.date = eventDate
            } else { event.date = "01/Jan/2017 12:00" }
            
            downloadComplete = AccessDatabase.writeEvent(event: event)
        }
    }

}
