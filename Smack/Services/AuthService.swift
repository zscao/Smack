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
        self.userData = UserData()
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
    
    public private(set) var userData: UserData
    
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
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                self.isLoggedIn = true
                
                completion(true, "logged in")
                
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
        
        let header: [String: String] = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if(response.result.error == nil) {
                guard let data = response.data else {
                    completion(false, "error data")
                    return
                }
                let json = JSON(data)
                let id = json["id"].stringValue
                let color = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                let email = json["email"].stringValue
                let name = json["name"].stringValue
                
                self.userData = UserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                
                completion(true, "user created.")
                
            } else {
                self.userData = UserData()
                debugPrint(response.result.error as Any)
                completion(false, "error")
            }
        }
    }
}
