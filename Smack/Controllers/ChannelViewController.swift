//
//  ChannelViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 19/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

}
