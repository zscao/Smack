//
//  SocketService.swift
//  Smack
//
//  Created by Zhengshan Cao on 29/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    private let socketManager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    private override init() {
        super.init()
    }
    
    func establishConnection() {
        socketManager.defaultSocket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        socketManager.defaultSocket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
        }
        
//        socketManager.defaultSocket.onAny { (event) in
//            debugPrint(event)
//        }
        
        socketManager.defaultSocket.connect()
    }
    
    func closeConnection() {
        socketManager.defaultSocket.disconnect()
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
        socketManager.defaultSocket.emit("newChannel", name, description)
        completion(true, "channel created")
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socketManager.defaultSocket.on("channelCreated") { (data, ack) in
            guard let name = data[0] as? String else { return }
            guard let description = data[1] as? String else { return }
            guard let id = data[2] as? String else { return }
            
            let channel = Channel(name: name, description: description, id: id)
            MessageService.instance.channels.append(channel)
            completion(true, "Got a new channel from socket")
        }
    }
}
