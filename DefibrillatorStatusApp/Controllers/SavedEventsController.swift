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
    
    // MARK : Properties
    let eventList = "Event List"
    let selectEvent = "Select an Event to view"
    var events : [Event] = []
    var selectedEvent : Event?
    @IBOutlet weak var eventListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = [Event]()
        events = getECGPointsFromDatabase()
        eventListTable.delegate = self
        eventListTable.dataSource = self
        eventListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "eventListToChartSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (events.count)
    }

    // MARK : Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventListToChartSegue") {
            if let eventThatWasSelected = selectedEvent {
                let svc = segue.destination as! ChartController;
                svc.selectedEvent = eventThatWasSelected
            }
        }
    }

    
    // MARK : Database Method
    
    func getECGPointsFromDatabase() -> [Event] {
        do {
            let realm = try Realm()
            let a = Array(realm.objects(Event.self))
            print(a)
            return Array(realm.objects(Event.self))
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}
