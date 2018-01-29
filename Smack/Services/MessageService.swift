//
//  MessageService.swift
//  Smack
//
//  Created by Zhengshan Cao on 28/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    private init() {
        channels = [Channel]()
    }
    
    public private(set) var channels: [Channel]
    
    func getAllChannels(completion: @escaping CompletionHandler) {
        
        channels.removeAll()
        
        Alamofire.request(URL_CHANNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {
                    completion(false, "no data")
                    return
                }
                
                if let json = JSON(data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        
                        let channel = Channel(name: name, description: description, id: id)
                        self.channels.append(channel)
                    }
                    completion(true, "total \(json.count) channels")
                } else {
                    completion(false, "empty list")
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false, "failed to load channels.")
            }
        }
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
        
        let body: [String: Any] = [
            "name": name,
            "description": description
        ]
        
        Alamofire.request(URL_ADD_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {
                    completion(false, "no data")
                    return
                }
                // let json = JSON(data)
                // let message = json["message"].stringValue
                // completion(true, message)
                
                // reload channels
                self.getAllChannels(completion: { (success, message) in
                    completion(success, message)
                })
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false, "failed to create channel")
            }
            
        }
    }
}
