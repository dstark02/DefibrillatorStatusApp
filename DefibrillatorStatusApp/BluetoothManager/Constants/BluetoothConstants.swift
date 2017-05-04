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
    static let serviceUUID = CBUUID(string: "7776A332-27D8-44DE-B92B-97AC0FAD7690")
    static let passwordCharacteristicUUID = CBUUID(string: "7776A332-27D8-44DE-B92B-97AC0FAD7691")
    static let eventListCharacteristicUUID = CBUUID(string: "7776A332-27D8-44DE-B92B-97AC0FAD7692")
    static let ecgDataCharacteristicUUID = CBUUID(string: "7776A332-27D8-44DE-B92B-97AC0FAD7693")
}
