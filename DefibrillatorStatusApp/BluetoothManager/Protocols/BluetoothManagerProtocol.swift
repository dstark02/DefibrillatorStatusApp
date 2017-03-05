//
//  BluetoothManagerProtocol.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerProtocol {
    
    var scanDelegate: ScanDelegate? { get set }
    var currentPeripheral : CBPeripheral? { get set }
    var characteristicDelegate : BluetoothCharacteristicDelegate? { get set }
    var downloadDelegate : DownloadDelegate? { get set }
    var defibrillatorList : [CBPeripheral] { get set }
    var eventList : [String] { get set }
    func isBluetoothOn() -> Bool
    func scanForDefibrillators()
    func connectToDefibrillator(peripheral : CBPeripheral)
    func downloadEvent(peripheral: CBPeripheral, date: String)
}
