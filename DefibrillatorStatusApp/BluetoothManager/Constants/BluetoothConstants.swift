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
    static let deviceSerialNumber = "12A345678910"
    static let serviceUUID = CBUUID(string: "12ab")
    static let passwordCharacteristicUUID = CBUUID(string: "9876")
    static let eventListCharacteristicUUID = CBUUID(string: "34cd")
    static let ecgDataCharacteristicUUID = CBUUID(string: "1234")
}
