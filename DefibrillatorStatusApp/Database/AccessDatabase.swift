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
    
    static func read() -> [Event] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Event.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    static func write(event: Event, date: String) -> Bool {
        var result = false
        event.date = date
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
}
