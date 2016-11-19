//
//  BluetoothConstants.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth

struct BluetoothConstants {
    static let serviceUUID = CBUUID(string: "12ab")
    static let characteristicUUID = CBUUID(string: "34cd")
}
