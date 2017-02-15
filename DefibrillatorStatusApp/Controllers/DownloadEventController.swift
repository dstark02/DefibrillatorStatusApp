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
    var selectedEvent : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothManager.downloadDelegate = self
        progressView.progress = valueAtBegining
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : Methods
    
    func progressHasUpdated(value: Float) {
        valueAtBegining = value
        progressView.setProgress(value, animated: true)
    }
    
    func downloadComplete(event: Event) {
        selectedEvent = event
        performSegue(withIdentifier: "downloadToChartSegue", sender: nil)
    }
    
    // MARK : Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "downloadToChartSegue") {
            if let eventThatWasSelected = selectedEvent {
                let svc = segue.destination as! ChartController;
                svc.selectedEvent = eventThatWasSelected
                svc.hideButton = false
            }
        }
    }

}
