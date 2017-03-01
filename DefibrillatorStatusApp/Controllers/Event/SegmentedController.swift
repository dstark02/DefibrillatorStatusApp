//
//  SegmentedController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 23/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class SegmentedController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var traceContainer: UIView!
    @IBOutlet weak var informationContainer: UIView!
  
    // MARK: ViewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action Method
    
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = .white
                self.traceContainer.alpha = 1
                self.informationContainer.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
                self.traceContainer.alpha = 0
                self.informationContainer.alpha = 1
            })
        }
    }
}
