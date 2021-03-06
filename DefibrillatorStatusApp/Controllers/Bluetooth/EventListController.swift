//
//  EventListController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit

class EventListController: UIViewController, UITableViewDelegate, UITableViewDataSource, CharacteristicDelegate {

    // MARK: Properties
    
    var bluetoothManager : BluetoothManagerProtocol!
    let eventList = "Event List"
    let selectEvent = "Select an Event to Download"
    @IBOutlet weak var eventListTable: UITableView!
    
    // MARK: viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.characteristicDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CharacteristicState Method
    
    /// Invoked when characteristic state has updated
    /// If app has discovered data from defibrillator
    /// Used to update view
    /// - Parameter characteristicState: state i.e found data, data has updated
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
            bluetoothManager.downloadEvent(peripheral: defibrillator, date: bluetoothManager.eventList[indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bluetoothManager.eventList.count)
    }
    
    // MARK : Segue
    
    /// Takes user to download screen
    /// Passes the bluetoothManager object to the next controller
    /// - Parameters:
    ///   - segue: segue
    ///   - sender: user selected event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "downloadSegue") {
            let svc = segue.destination as! DownloadEventController;
            svc.bluetoothManager = bluetoothManager
        }
    }

}
