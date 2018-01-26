//
//  RoundedButton.swift
//  Smack
//
//  Created by Zhengshan Cao on 26/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.setupView()
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupView()
    }
    
    private func setupView() {
        self.layer.cornerRadius = cornerRadius
    }

}
