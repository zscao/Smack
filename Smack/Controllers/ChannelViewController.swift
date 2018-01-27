//
//  ChannelViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 19/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImg: UIImageView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        let name = segue.identifier!
        print("back from unwind segue " + name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataChanged(_:)), name: NOTIF_USER_DATA_CHANGED, object: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            // show profile
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: false, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataChanged(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(AuthService.instance.userData.name, for: .normal)
            userImg.image = UIImage(named: AuthService.instance.userData.avatarName)
        }
        else {
            loginButton.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
        }
    }

}
