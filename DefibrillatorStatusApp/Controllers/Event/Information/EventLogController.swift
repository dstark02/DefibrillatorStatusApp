//
//  EventLogController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 06/04/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class EventLogController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: Properties
    
    @IBOutlet weak var eventLogTable: UITableView!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Event Log"
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventLogTable.dequeueReusableCell(withIdentifier: "eventLogCell") as! EventLogCell
        guard let markers = CurrentEventProvider.markers else { return cell }
        guard let markerText = Marker.markerDictionary[markers[indexPath.row].markerCode] else { return cell }
        cell.markerDescription.text = markerText[1]
        cell.markerTime.text = TimeCalculator.calculateTime(sample: markers[indexPath.row].markerSample)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = CurrentEventProvider.markers?.count else { return 0 }
        return count
    }
}
