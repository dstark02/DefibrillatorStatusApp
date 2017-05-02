//
//  PatientTests.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 17/03/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//


import XCTest
@testable import DefibrillatorStatusApp
import RealmSwift

class PatientTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "database A"
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPatientInitializer() {
        let name = "David"
        let gender = 0
        let dob = "29/Sep/1994"
        let patient = Patient(name: name, gender: gender, dob: dob, event: nil)
        
        
        XCTAssertEqual(patient.name, name)
        XCTAssertEqual(patient.gender, gender)
        XCTAssertEqual(patient.dob, dob)
        XCTAssertEqual(patient.event, nil)
    }
    
    func testWritePatient() {
        let patient = Patient(name: "David", gender: 0, dob: "29/Sep/1994", event: nil)
        XCTAssertTrue(AccessDatabase.writePatient(patient: patient))
    }
    
    func testRelationship() {
        let data = Data()
        let ecg = ECG(ecg: data)
        let event = Event()
        event.ecgs.append(ecg)
        event.date = "20/Mar/2017"
        
        let patient = Patient(name: "David", gender: 0, dob: "29/Sep/1994", event: event)
        
        XCTAssertTrue(AccessDatabase.writePatient(patient: patient))
        let patientFromDatabase = AccessDatabase.readPatients().last
        XCTAssertEqual(patient.name, patientFromDatabase?.name)
        XCTAssertEqual(patient.gender, patientFromDatabase?.gender)
        XCTAssertEqual(patient.dob, patientFromDatabase?.dob)
        XCTAssertEqual(patient.event, patientFromDatabase?.event)
    }
    
}
