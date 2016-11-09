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
    var bluetoothManager: BluetoothManagerProtocol?
    @IBOutlet weak var bluetoothScanView: UITableView!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    @IBOutlet weak var scanLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: viewDidLoad Method
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager = BluetoothManager()
        bluetoothManager?.delegate = self
        bluetoothScanView.delegate = self
        bluetoothScanView.dataSource = self
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func switchToggled(_ sender: Any) {
        if bluetoothSwitch.isOn {
            bluetoothManager?.scanForDefibrillators()
        } else {
            bluetoothManager?.stopScan()
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Defibrillators"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Select Device to see Events on it"
    }
    
    // MARK: Bluetooth State Method
    
    func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
        
        switch bluetoothState {
        case .Scanning:
            scanLabel.text = "SCANNING"
            scanLabel.isHidden = false
            activityIndicator.startAnimating()
        case.FoundDefibrillator:
            bluetoothScanView.reloadData()
            bluetoothScanView.isHidden = false
        case.Stopped:
            bluetoothSwitch.setOn(false, animated: true)
            scanLabel.text = "COULDN'T FIND DEVICE, MAKE SURE DEVICE IS IN RANGE"
            activityIndicator.stopAnimating()
        default: break
            
        }
    }
    
    
    // MARK: UITableView methods
    
    func tableView(_ cellForRowAttableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.bluetoothScanView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if let peripheralName = bluetoothManager?.defibrillatorList[indexPath.row] {
            cell.textLabel?.text = peripheralName
            return cell
        }
        
        cell.textLabel?.text = "nothing"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let _ = bluetoothManager?.defibrillatorList.count {
            return bluetoothManager!.defibrillatorList.count
        }
        return 0
    }
    
    
}

