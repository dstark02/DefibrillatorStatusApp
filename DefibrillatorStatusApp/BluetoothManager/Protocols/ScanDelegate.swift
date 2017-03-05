//
//  BluetoothManagerDelegate.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation

protocol ScanDelegate {
    
    func bluetoothStateHasChanged(bluetoothState: BluetoothState)
    func progressHasUpdated(value: Float)
}
