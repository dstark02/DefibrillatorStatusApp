//
//  LoginController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 20/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "skipLogin") {
            UserAccessRights.userHasFullAccess = false
        }
    }

}
