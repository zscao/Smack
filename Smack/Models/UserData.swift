//
//  UserData.swift
//  Smack
//
//  Created by Zhengshan Cao on 26/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import Foundation

class UserData {
    
    init(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    convenience init() {
        self.init(id: "", color: "", avatarName: "", email: "", name: "")
    }
    
    public private(set) var id: String
    public private(set) var avatarColor: String
    public private(set) var avatarName: String
    public private(set) var email: String
    public private(set) var name: String
    
    var isEmpty: Bool {
        get { return self.id == "" }
    }
}
