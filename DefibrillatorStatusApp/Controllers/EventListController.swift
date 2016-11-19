//
//  EventListController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/11/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit

class EventListController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothCharacteristicDelegate {

    var bluetoothManager : BluetoothManagerProtocol!
    @IBOutlet weak var eventListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.characteristicDelegate = self
        eventListTable.delegate = self
        eventListTable.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        return "Event List"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select an Event to view"
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventListTable.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let event = bluetoothManager.eventList[indexPath.row]
        cell.textLabel?.text = event
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bluetoothManager.eventList.count)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
