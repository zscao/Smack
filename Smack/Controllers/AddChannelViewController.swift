//
//  AddChannelViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 29/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelViewController.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else {
            return
        }
        guard let description = descriptionTxt.text else { return }
        
        MessageService.instance.addChannel(name: name, description: description) { (success, message) in
            debugPrint(message)
            
            if success {
                self.dismiss(animated: false, completion: nil)
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LIST_UPDATED, object: nil)
            }
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func closeTap(_ recognizer: UIGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
}
