//
//  Constants.swift
//  Smack
//
//  Created by Zhengshan Cao on 22/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool, _ messsage: String) -> ()

// URLs
let BASE_URL = "https://cschatchat.herokuapp.com/v1"
let URL_REGISTER = "\(BASE_URL)/account/register"
let URL_LOGIN = "\(BASE_URL)/account/login"


// SEGUES
let TO_LOGIN = "login"
let TO_CREATE_ACCOUNT = "createAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"

// USER DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// HTTP RESQUEST
let DEFAULT_HEADER: [String: String] = [
    "Content-Type": "application/json; charset=utf-8"
]
