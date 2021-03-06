//
//  LoginController.swift
//  DefibrillatorStatusApp
//
//  Created by David Stark on 20/02/2017.
//  Copyright © 2017 David Stark. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        authenticateUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Invoked when user taps login button
    /// Attempts to log user in, if fails it will alert the user
    /// - Parameter sender: <#sender description#>
    @IBAction func didTapLogin(_ sender: Any) {
        if isCorrectCredentials() {
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        } else {
            let ac = UIAlertController(title: "Login failed", message: "Invalid Credentials", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Attempts to authenticate user, if it can it will take user into application
    /// If not user will be alerted that the login has failed
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Touch to Log In"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Invalid User", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        }
    }
    
    /// Checks if users credentials are valid
    ///
    /// - Returns: True if valid, false if invalid
    func isCorrectCredentials() -> Bool {
        if username.text == "testuser" && password.text == "password" {
            return true
        }
        return false
    }

}
