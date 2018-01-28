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
                        let title = item["title"].stringValue
                        let description = item["description"].stringValue
                        
                        let channel = Channel(title: title, description: description, id: id)
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
}
