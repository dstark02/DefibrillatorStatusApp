//
//  SavedEventsController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 20/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit
import RealmSwift

class SavedEventsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    let eventList = "Event List"
    let selectEvent = "Select an Event to view"
    var events : [Event] = []
    @IBOutlet weak var eventListTable: UITableView!
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = [Event]()
        events = AccessDatabase.readEvents()
        eventListTable.reloadData()
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        } else {
            print("3D Touch Not Available")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventList
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return selectEvent
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventListTable.dequeueReusableCell(withIdentifier: "eventCell")! as UITableViewCell
        let event = events[indexPath.row]
        cell.textLabel?.text = event.date
        cell.textLabel?.textColor = Colour.HeartSineBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Make sure you set the current event that was selected
        CurrentEventProvider.currentEvent = events[indexPath.row]
        performSegue(withIdentifier: "eventListToChartSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (events.count)
    }
}
