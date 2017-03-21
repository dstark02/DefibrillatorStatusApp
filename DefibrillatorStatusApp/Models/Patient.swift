//
//  Patient.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 15/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation
import RealmSwift

class Patient : Object {
    dynamic var name = ""
    dynamic var gender = 0
    dynamic var dob = ""
    dynamic var event: Event?
}
