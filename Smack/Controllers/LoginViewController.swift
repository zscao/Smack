//
//  LoginViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 22/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameTxt.text, usernameTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.loginUser(email: username, password: password) { (success, message) in
            print(message)
            
            if success {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
            } else {
                self.errorLabel.text = message
            }
        }
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
