//
//  BluetoothState.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation

enum BluetoothState {
    case Off
    case Started
    case Scanning
    case Stopped
    case FoundDefibrillator
    case ConnectedToDefibrillator
}
