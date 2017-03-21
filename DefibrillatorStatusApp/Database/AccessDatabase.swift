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
    
    static func readEvents() -> [Event] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Event.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
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
    
    static func readPatients() -> [Patient] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Patient.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
    
}
