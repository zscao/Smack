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
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard let username = usernameTxt.text, usernameTxt.text != "" else {
            showError("please enter your email")
            return
        }
        guard let password = passwordTxt.text, passwordTxt.text != "" else {
            showError("please enter password")
            return
        }
        
        setButtonStatus(enabled: false)
        startSpinner()
        
        AuthService.instance.loginUser(email: username, password: password) { (success, message) in
            debugPrint(message)
            self.setButtonStatus(enabled: true)
            self.stopSpinner()
            
            if success {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
            } else {
                self.showError(message)
            }
        }
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setButtonStatus(enabled: Bool) {
        loginButton.isEnabled = enabled
        createButton.isEnabled = enabled
    }
    
    private func startSpinner() {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func stopSpinner() {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    private func setupView() {
        stopSpinner()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap))
        view.addGestureRecognizer(tap)
        
        usernameTxt.becomeFirstResponder()
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
    }
}
