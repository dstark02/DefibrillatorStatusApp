//
//  BluetoothScanController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 16/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit
import RealmSwift

class ScanController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothManagerDelegate {
    
    // MARK: Properties
    
    var bluetoothManager : BluetoothManagerProtocol!
    var state : BluetoothState?
    let titleForHeaderInSection = "Defibrillators"
    let titleForFooterInSection = "Select Device to see Events on it"
    @IBOutlet weak var bluetoothScanView: UITableView!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(Realm.Configuration.defaultConfiguration.description)
        bluetoothManager = BluetoothManager()
        bluetoothManager.delegate = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Bluetooth Methods
    
    @IBAction func switchToggled(_ sender: Any) {
        bluetoothInteraction()
    }
    
    func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
        
        state = bluetoothState
        
        switch bluetoothState {
            
        case .Scanning:
            updateScanningView()
        case.FoundDefibrillator:
            bluetoothScanView.reloadData()
            bluetoothScanView.isHidden = false
        case.Stopped:
            updateStoppedScanningView()
        default: break
            
        }
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bluetoothScanView.dequeueReusableCell(withIdentifier: "deviceCell")! as UITableViewCell
        // let peripheralName = bluetoothManager.defibrillatorList[indexPath.row].name
        cell.textLabel?.text = "HeartSine Defibrillator"
        cell.textLabel?.textColor = Colour.HeartSineBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bluetoothManager.defibrillatorList.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (state != .ConnectedToDefibrillator) {
            let defibrillator = bluetoothManager.defibrillatorList[indexPath.row]
            bluetoothManager.connectToDefibrillator(peripheral: defibrillator)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventListSegue") {
            let svc = segue.destination as! EventListController;
            svc.bluetoothManager = bluetoothManager
        }
    }
    
    // MARK: Helper Methods
    
    func updateScanningView() {
        scanLabel.text = "SCANNING"
        scanLabel.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func updateStoppedScanningView() {
        bluetoothSwitch.setOn(false, animated: true)
        scanLabel.text = "FINISHED SCAN, RETRY IF NO DEVICES LISTED"
        activityIndicator.stopAnimating()
    }
    
    func bluetoothInteraction() {
        if state == .Off {
            if !bluetoothSwitch.isOn { return }
            let alert = UIAlertController(title: "Bluetooth", message: "Turn Bluetooth On", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("bluetooth is off")
            bluetoothSwitch.setOn(false, animated: true)
        } else {
            
            if bluetoothSwitch.isOn {
                bluetoothManager.scanForDefibrillators()
            } else {
                bluetoothManager.stopScan()
            }
        }
    }
}

