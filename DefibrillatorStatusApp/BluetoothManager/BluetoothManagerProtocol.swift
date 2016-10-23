//
//  BluetoothManagerProtocol.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation

protocol BluetoothManagerProtocol {
    
    var delegate: BluetoothManagerDelegate? { get set}
    func scanForDefibrillators()
    var defibrillatorList : [String] { get set}
}
