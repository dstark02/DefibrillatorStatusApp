//
//  BluetoothCharacteristicDelegate.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation

protocol CharacteristicDelegate {
    
    func characteristicStateHasChanged(characteristicState: CharacteristicState)
}
