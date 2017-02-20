//
//  TabBarController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 20/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var hasFullAccess = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if tabBarController.selectedIndex == 0 {
            
            if (UserAccessRights.userHasFullAccess == false) {
                let ac = UIAlertController(title: "", message: "You don't have access to saved events as you skipped login", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }

            return UserAccessRights.userHasFullAccess
        }
        return true
    }

}
