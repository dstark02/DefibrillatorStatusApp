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
    let titleForHeaderInSection = "Defibrillators"
    let titleForFooterInSection = "Select Device to see Events on it"
    let titleForSerialAlert = "Please enter the Serial Number of the HeartSine AED"
    @IBOutlet weak var bluetoothScanView: UITableView!
    @IBOutlet weak var bluetoothSwitch: UISwitch!
    @IBOutlet weak var scanLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(Realm.Configuration.defaultConfiguration.description)
        bluetoothManager = BluetoothManager()
        bluetoothManager.scanDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Bluetooth Methods
    
    /// Invoked when user toggles switch
    ///
    /// - Parameter sender: user tap
    @IBAction func switchToggled(_ sender: Any) {
        bluetoothInteraction()
    }
    
    /// Begins bluetooth interactions, so scans for devices
    /// If Bluetooth is off, user will be alerted to turn it on
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
    
    // MARK: Delegate Callbacks
    
    /// Invoked when the bluetooth state has changed
    /// Used to update the view
    /// - Parameter bluetoothState: i.e scanning, stopped, found device
    func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
        
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
    
    /// Invoked when the scan progress has updated
    /// Updates the the progress bar on the view
    /// - Parameter value: scan progress value
    func progressHasUpdated(value: Float) {
        progressView.setProgress(value, animated: true)
    }
    
    /// Invoked when the password/serial has been retrieved from
    /// the connected defibrillator, user must enter correct serial
    /// to gain access to the data on the defibrillator
    /// if incorrect user will be disconnected from device
    /// - Parameter password: the password received from the device
    func passwordReceived(password: String) {
        var serialNoTextField: UITextField?
        let ac = UIAlertController(title: "Serial Number", message: titleForSerialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        let enterAction = UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: {
                
                (_)in
                if let serialNo = serialNoTextField?.text {
                    if serialNo == password {
                        // let defibrillator = self.bluetoothManager.defibrillatorList[indexPath.row]
                        // self.bluetoothManager.connectToDefibrillator(peripheral: defibrillator)
                        ac.dismiss(animated: false, completion: nil)
                        self.performSegue(withIdentifier: "eventListSegue", sender: self)
                        
                    } else {
                        self.bluetoothManager.disconnectFromDefibrillator()
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
        let defibrillator = bluetoothManager.defibrillatorList[indexPath.row]
        bluetoothManager.connectToDefibrillator(peripheral: defibrillator)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Helper Methods
    
    /// Helper method called when serial entered incorrectly, to update the view
    func incorrectSerialNo() {
        emptyDefibrillatorList()
        bluetoothScanView.isHidden = true
        bluetoothScanView.reloadData()
        alertControllerHelper(title: "Incorrect Serial", message: "Please Wait for the Scan in Progress to Complete")
    }
    
    /// Removes all defibrillators found from array that is used for the table
    func emptyDefibrillatorList() {
        if(!bluetoothManager.defibrillatorList.isEmpty) {
            bluetoothManager.defibrillatorList.removeAll()
        }
    }
    
    /// Updates the view when scanning
    func updateScanningView() {
        scanLabel.text = "SCANNING"
        scanLabel.isHidden = false
    }
    
    /// Updates the view when scanning has stopped
    func updateStoppedScanningView() {
        bluetoothSwitch.setOn(false, animated: true)
        scanLabel.text = "FINISHED SCAN, RETRY IF NO DEVICES LISTED"
    }
    
    // MARK: AlertController Helper
    
    /// Helper method to present alerts to the user, i.e message box
    ///
    /// - Parameters:
    ///   - title: title of alert
    ///   - message: message of alert
    func alertControllerHelper(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    // MARK: Segue
    
    /// Takes user to event list screen
    /// Passes the bluetoothManager object to the next controller
    /// - Parameters:
    ///   - segue: segue
    ///   - sender: user entered correct serial
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventListSegue") {
            let svc = segue.destination as! EventListController;
            svc.bluetoothManager = bluetoothManager
        }
    }
}

