//
//  ECG.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 17/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation
import RealmSwift

class ECG: Object {
    dynamic var ecg: Data = Data()
}
