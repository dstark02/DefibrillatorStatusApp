//
//  EventListController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit

class EventListController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothCharacteristicDelegate {

    // MARK: Properties
    
    var bluetoothManager : BluetoothManagerProtocol!
    let eventList = "Event List"
    let selectEvent = "Select an Event to view"
    @IBOutlet weak var eventListTable: UITableView!
    
    // MARK: viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.characteristicDelegate = self
        eventListTable.delegate = self
        eventListTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CharacteristicState Method
    
    func characteristicStateHasChanged(characteristicState: CharacteristicState) {
        
        switch characteristicState {
        case .Found:
            eventListTable.reloadData()
        case.Updated:
            eventListTable.reloadData()
        default: break
        }
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventList
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return selectEvent
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventListTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let event = bluetoothManager.eventList[indexPath.row]
        cell.textLabel?.text = event
        cell.textLabel?.textColor = Colour.HeartSineBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let defibrillator = bluetoothManager.currentPeripheral {
            bluetoothManager.downloadEvent(peripheral: defibrillator)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bluetoothManager.eventList.count)
    }
    
    // MARK : Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "downloadSegue") {
            let svc = segue.destination as! DownloadEventController;
            svc.bluetoothManager = bluetoothManager
        }
    }

}
