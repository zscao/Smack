//
//  ChatViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 19/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        loadChannels()
    }

    
    private func loadChannels() {
        MessageService.instance.getAllChannels { (success, message) in
            debugPrint(message)
            
            if success {
                for channel in MessageService.instance.channels {
                    debugPrint(channel.name)
                }
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LIST_UPDATED, object: nil)
            }
        }
        
        SocketService.instance.getChannel { (success, message) in
            debugPrint(message)
            
            if success {
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LIST_UPDATED, object: nil)
            }
        }
    }

}
