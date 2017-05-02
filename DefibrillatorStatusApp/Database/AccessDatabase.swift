//
//  AccessDatabase.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 25/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import Foundation
import RealmSwift


class AccessDatabase {
    
    
    /// Reads events saved in database
    /// and returns them to user
    /// - Returns: Array of events
    static func readEvents() -> [Event] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Event.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
    /// Write event downloaded from defibrillator to database
    ///
    /// - Parameter event: event to write
    /// - Returns: true if data was persisted successfully
    static func writeEvent(event: Event) -> Bool {
        var result = false
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(event)
                print("value wrote")
                result = true
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        return result
    }
    
    
    /// Reads patients saved in database
    /// and returns them to user
    /// - Returns: Array of patients
    static func readPatients() -> [Patient] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Patient.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
    /// Write patient object to database
    ///
    /// - Parameter patient: patient object - includes their details
    /// - Returns: true if data was persisted successfully
    static func writePatient(patient: Patient) -> Bool {
        var result = false
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(patient)
                print("value wrote")
                result = true
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        return result
    }
    
    
    
    
    
}
