//
//  CreateAccountViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 22/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success, message) in
            print(message)
            
            if success {
                AuthService.instance.loginUser(email: email, password: password) { (success, message) in
                    print(message)
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success, message) in
                            
                            print(message)
                            
                            if(success) {
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
                            } else {
                                
                            }
                        }
                        
                    } else {
                        print("failed to login user")
                    }
                }
            }
            else {
                print("failed to register user")
            }
        }
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func generateBgColorPressed(_ sender: Any) {
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
}
