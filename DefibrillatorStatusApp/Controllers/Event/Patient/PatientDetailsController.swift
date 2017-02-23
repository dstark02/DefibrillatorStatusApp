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
    
    @IBOutlet weak var patientTable: UITableView!
    let patientDetails = "Patient Details"
    var isDatePickerHidden = true
    let datePickerRow = 3
    let dobRow = 2
    let datePickerHeight : CGFloat = 188
    
    // MARK: ViewDidLoad Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action Methods
    
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
            return cell
        case 1:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "genderCell") as! GenderCell
            return cell
        case 2:
            let cell = patientTable.dequeueReusableCell(withIdentifier: "dobCell") as! DOBCell
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
    
    // MARK: DatePicker Helper Methods
    
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
}
