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
    
    var delegate: BluetoothManagerDelegate? { get set }
    var characteristicDelegate : BluetoothCharacteristicDelegate? { get set }
    var downloadDelegate : DownloadDelegate? { get set }
    var defibrillatorList : [CBPeripheral] { get set }
    var eventList : [String] { get set }
    func scanForDefibrillators()
    func stopScan()
    func connectToDefibrillator(peripheral : CBPeripheral)
}
