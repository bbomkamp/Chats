//
//  FirebaseConstants.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//
/**
 This code defines a struct called FirebaseConstants that includes various static properties that represent key names for specific data fields in Firebase Firestore database.

 fromId, toId, text, and timestamp are keys for the ChatMessage struct that stores chat messages.
 email, uid, and profileImageUrl are keys for the ChatUser struct that stores user information.
 messages, users, and recentMessages are the keys for Firestore collections used to store messages, users, and recent messages respectively.
 By defining these constants in a separate struct, it makes it easier to refer to these keys throughout the code, which helps prevent typos and improves code readability.
 */

import Foundation

struct FirebaseConstants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
    static let uid = "uid"
    static let profileImageUrl = "profileImageUrl"
    static let messages = "messages"
    static let users = "users"
    static let recentMessages = "recent_messages"
}
