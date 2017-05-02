//
//  BluetoothManager.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 19/10/2016.
//  Copyright © 2016 David Stark. All rights reserved.
//

import Foundation
import CoreBluetooth
import RealmSwift

class BluetoothManager: NSObject, BluetoothManagerProtocol, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: Properties
    var centralManager : CBCentralManager?
    var currentPeripheral : CBPeripheral?
    var defibrillatorList: [CBPeripheral]
    var eventList: [String]
    var fileLength : Float
    let event : Event
    var date : String?
    var timer = Timer()
    var scanDelegate : ScanDelegate?
    var bluetoothState : BluetoothState {
        didSet {
            scanDelegate?.bluetoothStateHasChanged(bluetoothState: bluetoothState)
        }
    }
    var scanProgress : Float {
        didSet {
            scanDelegate?.progressHasUpdated(value: scanProgress)
        }
    }
    var characteristicDelegate : CharacteristicDelegate?
    var characteristicState : CharacteristicState {
        didSet {
            characteristicDelegate?.characteristicStateHasChanged(characteristicState: characteristicState)
        }
    }
    var downloadDelegate : DownloadDelegate?
    var downloadProgress : Float {
        didSet {
            // Update progress for UI
            downloadDelegate?.progressHasUpdated(value: downloadProgress)
        }
    }
    var downloadComplete : Bool {
        didSet {
            if (downloadComplete) {
                // Let Controller know download has completed
                downloadDelegate?.downloadComplete(event: event)
            }
        }
    }
    
    // MARK: Initialiser
    
    override init() {
        bluetoothState = .Started
        characteristicState = .NotFound
        scanProgress = 0
        downloadComplete = false
        downloadProgress = 0
        fileLength = 0
        //date = nil
        defibrillatorList = [CBPeripheral]()
        eventList = [String]()
        event = Event()
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    //MARK: Central Methods
    
    /// Initiates a Bluetooth scan for defibrillators
    /// with the the same UUID as is in BluetoothConstants class
    func scanForDefibrillators() {
        if bluetoothState != .Scanning {
            centralManager?.scanForPeripherals(withServices: [BluetoothConstants.serviceUUID], options: nil)
            bluetoothState = .Scanning
            print("scanning")
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(BluetoothManager.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    /// Invoked when the central manager discovers a defibrillator while scanning
    ///
    /// - Parameters:
    ///   - central: <#central description#>
    ///   - peripheral: Defibrillator found
    ///   - advertisementData: Defibrillator advertisement data
    ///   - RSSI: RSSI
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        defibrillatorList.append(peripheral)
        bluetoothState = .FoundDefibrillator
        print("Found")
    }
    
    
    /// Update Bluetooth scan timer, scans for 10 seconds
    func updateTimer() {
        scanProgress += 0.01
        if scanProgress > Float(1){
            timer.invalidate()
            scanProgress = 0
            stopScan()
        }
    }
    
    
    /// Check if device Bluetooth is on
    ///
    /// - Returns: if true Bluetooth is on
    func isBluetoothOn() -> Bool {
        if centralManager?.state == .poweredOn {
            return true
        }
        return false
    }
    
    /// Used to stop the current Bluetooth scan
    func stopScan() {
        if (isBluetoothOn()) {
            centralManager?.stopScan()
            bluetoothState = .Stopped
        }
    }
    
    
    /// Connect to defibrillator retrieved from Bluetooth scan
    ///
    /// - Parameter peripheral: peripheral to connect to
    func connectToDefibrillator(peripheral : CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
    }
    
    /// Disconnect from currently connected Defibrillator
    func disconnectFromDefibrillator() {
        guard let peripherals = centralManager?.retrieveConnectedPeripherals(withServices: [BluetoothConstants.serviceUUID]) else { return }
        
        if !peripherals.isEmpty {
            eventList.removeAll()
            centralManager?.cancelPeripheralConnection(peripherals[0])
        }
    }
    
    
    /// Invoked when a connection is successfully created with a defibrillator
    ///
    /// - Parameters:
    ///   - central: central manager providing this information
    ///   - peripheral: defibrillator that has been connected to the system
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        currentPeripheral = peripheral
        currentPeripheral?.delegate = self
        bluetoothState = .ConnectedToDefibrillator
        print("Connected to Defib")
        discoverDefibrillatorServices()
    }
    
    /// Invoked when an existing connection with a defibrillator is torn dow
    ///
    /// - Parameters:
    ///   - central: central manager providing this information
    ///   - peripheral: defibrillator that has been disconnected from the system
    ///   - error: Description if error occurred
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?){
        print("Disconnected")
        if scanProgress == 0 {
           bluetoothState = .Stopped
        }
    }

    // MARK: CBCentral required method
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case.poweredOn:
            bluetoothState = .Started
            print("Bluetooth is on")
        case.poweredOff:
            print("Turn Bluetooth on")
        case.unauthorized:
            print("Unautorized")
        case.resetting:
            print("resetting")
        case.unknown:
            print("unknown")
        case.unsupported:
            print("Unsupported")
        }
    }
    
}
