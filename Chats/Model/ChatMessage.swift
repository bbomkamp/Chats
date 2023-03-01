//
//  ChatMessage.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//

/**
 This code imports two modules: Foundation and FirebaseFirestoreSwift.

 The ChatMessage struct is defined with properties to represent a message in a chat app. It conforms to the Codable and Identifiable protocols, which allows it to be easily encoded and decoded to/from JSON, as well as uniquely identifiable.

 The id property is a unique identifier for the message, while fromId and toId represent the sender and recipient of the message, respectively. The text property is the content of the message, and timestamp is the date and time that the message was sent.

 In summary, this code defines a ChatMessage struct with properties to represent a message in a chat app, and conforms to Codable and Identifiable protocols.
 */

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    let id: String
    let fromId, toId, text: String
    let timestamp: Date
}
