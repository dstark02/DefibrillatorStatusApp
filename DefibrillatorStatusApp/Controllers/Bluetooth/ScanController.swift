//
//  BluetoothScanController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 16/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import UIKit
import RealmSwift

class ScanController: UIViewController, UITableViewDelegate, UITableViewDataSource, ScanDelegate {
    
    // MARK: Properties
    
    var bluetoothManager : BluetoothManagerProtocol!
    var state : BluetoothState?
    let titleForHeaderInSection = "Defibrillators"
    let titleForFooterInSection = "Select Device to see Events on it"
    @IBOutlet weak var bluetoothScanView: UITableView!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.description)
        bluetoothManager = BluetoothManager()
        bluetoothManager.scanDelegate = self
        progressView.progress = 0
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
            bluetoothSwitch.isUserInteractionEnabled = true
            updateStoppedScanningView()
        default: break
            
        }
    }
    
    func progressHasUpdated(value: Float) {
        progressView.setProgress(value, animated: true)
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
        enterSerial(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Helper Methods
    
    func updateScanningView() {
        scanLabel.text = "SCANNING"
        scanLabel.isHidden = false
    }
    
    func updateStoppedScanningView() {
        bluetoothSwitch.setOn(false, animated: true)
        scanLabel.text = "FINISHED SCAN, RETRY IF NO DEVICES LISTED"
    }
    
    func incorrectSerialNo() {
        emptyDefibrillatorList()
        bluetoothScanView.isHidden = true
        bluetoothScanView.reloadData()
        alertControllerHelper(title: "Incorrect Serial", message: "Please Wait for the Scan in Progress to Complete")
    }
    
    func bluetoothInteraction() {
        if bluetoothManager.isBluetoothOn() {
            bluetoothSwitch.isUserInteractionEnabled = false
            emptyDefibrillatorList()
            bluetoothScanView.reloadData()
            bluetoothManager.scanForDefibrillators()
        } else {
            if !bluetoothSwitch.isOn { return }
            alertControllerHelper(title: "Bluetooth", message: "Turn Bluetooth On")
            print("bluetooth is off")
            bluetoothSwitch.setOn(false, animated: true)
        }
    }
    
    func enterSerial(indexPath: IndexPath) {
        
            var serialNoTextField: UITextField?
            let ac = UIAlertController(title: "Serial Number", message: "Please enter the Serial Number of the HeartSine AED",
                preferredStyle: UIAlertControllerStyle.alert)
        
            let enterAction = UIAlertAction(
            title: "Enter", style: UIAlertActionStyle.default, handler: {
                
                (_)in
                if let serialNo = serialNoTextField?.text {
                    if serialNo == BluetoothConstants.deviceSerialNumber {
                        let defibrillator = self.bluetoothManager.defibrillatorList[indexPath.row]
                        self.bluetoothManager.connectToDefibrillator(peripheral: defibrillator)
                        self.performSegue(withIdentifier: "eventListSegue", sender: self)
                    } else {
                        self.incorrectSerialNo()
                    }
                }
                
            })
        
            ac.addTextField {
                (txtSerialNo) -> Void in
                serialNoTextField = txtSerialNo
                serialNoTextField!.placeholder = "Enter Serial Number here"
            }
        
            ac.addAction(enterAction)
            self.present(ac, animated: true, completion: nil)
    }
    
    func emptyDefibrillatorList() {
        if(!bluetoothManager.defibrillatorList.isEmpty) {
            bluetoothManager.defibrillatorList.removeAll()
        }
    }
    
    // MARK: AlertController Helper
    
    func alertControllerHelper(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventListSegue") {
            let svc = segue.destination as! EventListController;
            svc.bluetoothManager = bluetoothManager
        }
    }
}

