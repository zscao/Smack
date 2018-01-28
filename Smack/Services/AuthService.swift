//
//  AuthService.swift
//  Smack
//
//  Created by Zhengshan Cao on 25/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    private init() {
        // self.userData = UserData()
    }
    
    private let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var userData: UserData {
        get {
            if let obj = defaults.value(forKey: USER_DATA) as? NSData {
                return NSKeyedUnarchiver.unarchiveObject(with: obj as Data) as! UserData
            }
            return UserData()
        }
        set {
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: USER_DATA)
        }
    }
    
    //public private(set) var userData: UserData
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCasedEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: DEFAULT_HEADER).responseString { (response) in
            if response.result.error == nil {
                completion(true, "registered")
            } else {
                completion(false, "error")
                debugPrint(response.result.error as Any)
            }

        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCasedEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: DEFAULT_HEADER).responseJSON { (response) in
            
            if(response.result.error == nil) {
                  // deal with json in swift way
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                    completion(true, "logged in")
//                    self.isLoggedIn = true
//                }
//                else {
//                    completion(false, "could not log in. please try again.")
//                }
                
                // deal with json in SwiftJSON
                guard let data = response.data else {
                    completion(false, "error data")
                    return
                }
                
                let json = JSON(data)
                let token = json["token"].stringValue
                
                if token == "" {
                    let message = json["message"].stringValue
                    completion(false, message)
                    return
                }
                
                self.authToken = token
                self.userEmail = json["user"].stringValue
                self.isLoggedIn = true
                
                // get user data
                self.findUserByEmail(email: lowerCasedEmail) { (success, message, data) in
                    print(message)
                    if success {
                        if let d = data as UserData! {
                            self.userData = d
                            completion(true, "logged in")
                        } else {
                            self.logoutUser()
                            completion(false, "cannot find user profile")
                        }
                    } else {
                        self.logoutUser()
                        completion(false, message)
                    }
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false, "error")
            }
        }
    }
    
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let lowerCasedEmail = email.lowercased()
        
        let body: [String: Any] = [
            "name": name,
            "email": lowerCasedEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if(response.result.error == nil) {
                guard let data = response.data else {
                    completion(false, "error data")
                    return
                }
                self.userData = self.getUserInfoData(data: data)
                
                completion(true, "user created.")
                
            } else {
                self.userData = UserData()
                debugPrint(response.result.error as Any)
                completion(false, "error")
            }
        }
    }
    
    func findUserByEmail(email: String, completion: @escaping CompletionWithDataHandler<UserData>) {
        
        if authToken == "" {
            completion(false, "Not authorised", nil)
            return;
        }
        
        let lowerCasedEmail = email.lowercased()
        
        Alamofire.request("\(URL_FIND_USER_BY_EMAIL)\(lowerCasedEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if(response.result.error == nil) {
                guard let data = response.data else {
                    completion(false, "error data", nil)
                    return
                }
                
                let result = self.getUserInfoData(data: data)
                completion(true, "user loaded.", result)
                
            } else {
                self.userData = UserData()
                debugPrint(response.result.error as Any)
                completion(false, "error", nil)
            }
        }
    }
    
    func logoutUser() {
        self.isLoggedIn = false
        self.authToken = ""
        self.userEmail = ""
        
        self.userData = UserData()
    }
    
    private func getUserInfoData(data: Data) -> UserData {
        let json = JSON(data)
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
    
        return UserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
    }
}
