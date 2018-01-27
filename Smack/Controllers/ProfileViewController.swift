//
//  ProfileViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 27/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        setupView()
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        AuthService.instance.logoutUser()
        dismiss(animated: false, completion: nil)
        
        NotificationCenter.default.post(name: NOTIF_USER_DATA_CHANGED, object: nil)
    }
    
    private func setupView() {
        if AuthService.instance.isLoggedIn && AuthService.instance.userData.isEmpty == false {
            let data = AuthService.instance.userData
            
            profileImg.image = UIImage(named: data.avatarName)
            userName.text = data.name
            userEmail.text = data.email
        } else {
            profileImg.image = UIImage(named: PROFILE_DEFAULT)
            userName.text = ""
            userEmail.text = ""
        }
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}
