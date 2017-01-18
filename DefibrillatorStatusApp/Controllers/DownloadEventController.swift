//
//  DownloadEventController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 18/01/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class DownloadEventController: UIViewController, DownloadDelegate {
    
    // MARK : Properties

    var bluetoothManager : BluetoothManagerProtocol!
    @IBOutlet weak var progressView: UIProgressView!
    var valueAtBegining = Float(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.downloadDelegate = self
        progressView.progress = valueAtBegining
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func progressHasUpdated(value: Float) {
        valueAtBegining = value
        progressView.setProgress(value, animated: true)
        
        if (value > 0.998) {
            performSegue(withIdentifier: "chartSegue", sender: nil)
        }
    }

}
