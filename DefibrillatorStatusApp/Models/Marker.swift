//
//  Marker.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 05/04/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation

class Marker {
    
    static let markerDictionary: [UInt16:[String]] = [2: ["Monitor Mode", "AED has entered Monitor Mode"], 3: ["CPR Mode", "AED has entered CPR Mode"]]
    
    var markerCode: UInt16 = 0
    var markerValue: UInt32 = 0
    var markerSample: UInt32 = 0
    
    convenience init(markerCode: UInt16, markerValue: UInt32, markerSample: UInt32) {
        self.init()
        self.markerCode = markerCode
        self.markerValue = markerValue
        self.markerSample = markerSample
    }
}
