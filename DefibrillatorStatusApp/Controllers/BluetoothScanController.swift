//
//  BluetoothScanController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 16/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit

class BluetoothScanController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothManagerDelegate {
    
    // MARK: Properties
    
    var bluetoothManager : BluetoothManagerProtocol!
    @IBOutlet weak var bluetoothScanView: UITableView!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager = BluetoothManager()
        bluetoothManager.delegate = self
        bluetoothScanView.delegate = self
        bluetoothScanView.dataSource = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventListSegue") {
            let svc = segue.destination as! EventListController;
            svc.bluetoothManager = bluetoothManager
        }
    }
    
    // MARK: Bluetooth Methods
    
    @IBAction func switchToggled(_ sender: Any) {
        if bluetoothSwitch.isOn {
            bluetoothManager.scanForDefibrillators()
        } else {
            bluetoothManager.stopScan()
        }
    }
    
    func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
        
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
        return "Defibrillators"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select Device to see Events on it"
    }
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bluetoothScanView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        let peripheralName = bluetoothManager.defibrillatorList[indexPath.row].name
        cell.textLabel?.text = peripheralName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bluetoothManager.defibrillatorList.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defibrillator = bluetoothManager.defibrillatorList[indexPath.row]
        bluetoothManager.connectToDefibrillator(peripheral: defibrillator)
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
}

