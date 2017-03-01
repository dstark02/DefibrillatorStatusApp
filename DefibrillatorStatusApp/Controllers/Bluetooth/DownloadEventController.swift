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
    var startValue = Float(0)
    var selectedEvent : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.downloadDelegate = self
        progressView.progress = startValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : Methods
    
    func progressHasUpdated(value: Float) {
        startValue = value
        progressView.setProgress(value, animated: true)
    }
    
    func downloadComplete(event: Event) {
        let alert = UIAlertController(title: "Download Complete", message: "Event: " + event.date + " successfully downloaded.\nLocated in Saved Events", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "downloadCompleteSegue", sender: self)
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
