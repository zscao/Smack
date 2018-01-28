//
//  UserData.swift
//  Smack
//
//  Created by Zhengshan Cao on 26/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import Foundation

class UserData: NSObject, NSCoding {
    
    init(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    convenience override init() {
        self.init(id: "", color: "", avatarName: "", email: "", name: "")
    }
    
    var id: String
    var avatarColor: String
    var avatarName: String
    var email: String
    var name: String
    
    var isEmpty: Bool {
        get { return self.id == "" }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.avatarColor, forKey: "avatarColor")
        aCoder.encode(self.avatarName, forKey: "avatarName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.avatarColor = aDecoder.decodeObject(forKey: "avatarColor") as! String
        self.avatarName = aDecoder.decodeObject(forKey: "avatarName") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
    }
}
