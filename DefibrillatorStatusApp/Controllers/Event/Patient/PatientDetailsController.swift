//
//  PatientDetailsController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 22/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class PatientDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var patientTable: UITableView!
    let patientDetails = "Patient Details"
    let datePickerRow = 3
    let dobRow = 2
    let datePickerHeight : CGFloat = 188
    var savedPatients : [Patient] = []
    var isDatePickerHidden = true
    
    // MARK: ViewDidLoad Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedPatients = AccessDatabase.readPatients()
        if getCurrentPatient() != nil {
            patientTable.isUserInteractionEnabled = false
            saveButton.isHidden = true
        }
        patientTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action Methods
    
    /// Invoked when user taps save button
    ///
    /// - Parameter sender: user tap
    @IBAction func saveButtonTapped(_ sender: Any) {
        savePatient()
    }
    
    /// Invoked when used has interacted with datePicker
    ///
    /// - Parameter sender: user interaction
    @IBAction func datePickerChanged(_ sender: Any) {
        datePickerChanged()
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return patientDetails
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        case 0:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "nameCell") as! NameCell
            if !savedPatients.isEmpty {
                cell.nameTextField?.text = getCurrentPatient()?.name
            }
            return cell
        case 1:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "genderCell") as! GenderCell
            if !savedPatients.isEmpty {
                cell.genderSegControl.selectedSegmentIndex = getCurrentPatient()?.gender ?? 0
            }
            return cell
        case 2:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "dobCell") as! DOBCell
            if !savedPatients.isEmpty {
                cell.dobValue.text = getCurrentPatient()?.dob
            }
            return cell
        default:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "datePickerCell") as! DatePickerCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == dobRow {
            toggleDatepicker()
            patientTable.deselectRow(at: indexPath, animated: true)
        } else if indexPath.row == 1 {
            patientTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isDatePickerHidden && indexPath.row == datePickerRow {
            return 0
        } else if !isDatePickerHidden && indexPath.row == datePickerRow {
            return datePickerHeight
        } else {
            return patientTable.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // MARK: Patient Methods
    
    /// Retrieves patient object that was saved for this event
    /// If patient details haven't yet been saved, it will return nil
    /// - Returns: Patient or nil
    func getCurrentPatient() -> Patient? {
        if !savedPatients.isEmpty {
            if let i = savedPatients.index(where: { $0.event == CurrentEventProvider.currentEvent }) {
                return savedPatients[i]
            }
        }
        return nil
    }
    
    /// Used to saved patient details
    /// Retrieves data inputed into the table cells and creates a Patient Object
    /// This object is then persisted to the database and user will be alerted
    func savePatient() {
        if !detailsValid() {
            alertControllerHelper(title: "Details Invalid", message: "You have missed out some details")
            return
        }
        
        // Table Cells
        let nameCell = patientTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! NameCell
        let genderCell = patientTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! GenderCell
        let dobCell = patientTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! DOBCell
        
        // Create Patient Object
        let patient = Patient()
        patient.name = nameCell.nameTextField.text!
        patient.gender = genderCell.genderSegControl.selectedSegmentIndex
        patient.dob = dobCell.dobValue.text!
        
        // Retrieve current event to save patient to
        if let event = CurrentEventProvider.currentEvent {
           patient.event = event
        } else { return }
        
        if AccessDatabase.writePatient(patient: patient) {
            saveButton.isHidden = true
            patientTable.isUserInteractionEnabled = false
            alertControllerHelper(title: "Save Complete", message: "Patient Details sucessfully saved")
        }
    }
    
    // MARK: Helper Methods
    
    /// Sets the DOB cell to value of datepicker
    func datePickerChanged() {
        let dobCell = patientTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! DOBCell
        let datePickerCell = patientTable.cellForRow(at: IndexPath(row: 3, section: 0)) as! DatePickerCell
        dobCell.dobValue.text = DateFormatter.localizedString(from: datePickerCell.datePicker.date, dateStyle: .medium, timeStyle: .none)
    }
    
    func toggleDatepicker() {
        isDatePickerHidden = !isDatePickerHidden
        patientTable.beginUpdates()
        patientTable.endUpdates()
    }
    
    /// Checks if the details entered are valid
    ///
    /// - Returns: true if valid, false if invalid
    func detailsValid() -> Bool {
        let nameCell = patientTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! NameCell
        let dobCell = patientTable.cellForRow(at: IndexPath(row: 2, section: 0)) as! DOBCell
        
        if (nameCell.nameTextField.text?.isEmpty)! { return false }
        if (dobCell.dobValue.text?.isEmpty)! { return false }
        
        return true
    }
    
    /// Helper method to display alert to user (messagebox)
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    func alertControllerHelper(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
}
