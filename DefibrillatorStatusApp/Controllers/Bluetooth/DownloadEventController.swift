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
    
    @IBOutlet weak var progressView: UIProgressView!
    var bluetoothManager : BluetoothManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.downloadDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : Methods
    
    /// Invoked when the download progress has updated
    /// Updates the progress bar on the view
    /// - Parameter value: download progress value
    func progressHasUpdated(value: Float) {
        progressView.setProgress(value, animated: true)
    }
    
    /// Invoked when download has completed
    /// Alerts user that download has finished
    /// - Parameter event: Event object that was downloaded
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
