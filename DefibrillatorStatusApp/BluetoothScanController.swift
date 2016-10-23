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
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var bluetoothScanView: UITableView!
    var bluetoothManager: BluetoothManagerProtocol?
    
    // MARK: viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothManager = BluetoothManager()
        bluetoothManager?.delegate = self
        
        bluetoothScanView.delegate = self
        bluetoothScanView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Bluetooth State Method
    
    func bluetoothStateHasChanged(bluetoothState: BluetoothState) {
        
        switch bluetoothState {
        case .Scanning:
            label.text = "Scanning"
        case.FoundDefibrillator:
            label.text = "Found Defibrillator"
            bluetoothScanView.reloadData()
        default:
            label.text = "Waiting"
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

