//
//  EventInformationController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 23/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class EventInformationController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    
    @IBOutlet weak var eventInfoTable: UITableView!
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Event Information"
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = eventInfoTable.dequeueReusableCell(withIdentifier: "eventInfoCell") as! EventInfoCell
            cell.cellTitle.text = "Event Time"
            cell.cellValue.text = CurrentEventProvider.currentEvent?.date
            return cell
        case 1:
            let cell = eventInfoTable.dequeueReusableCell(withIdentifier: "eventInfoCell") as! EventInfoCell
            cell.cellTitle.text = "Duration"
            cell.cellValue.text = EventDurationCalculator.getEventDuration()
            return cell
        case 2:
            let cell = eventInfoTable.dequeueReusableCell(withIdentifier: "eventInfoCell") as! EventInfoCell
            cell.cellTitle.text = "Number of Shocks"
            cell.cellValue.text = ""
            return cell
        default:
            let cell = eventInfoTable.dequeueReusableCell(withIdentifier: "patientCell") as! PatientDetailsCell
            cell.cellTitle.text = "Patient Information"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            eventInfoTable.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
