//
//  RecentMessage.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//

/**
 This code defines a RecentMessage struct which conforms to the Codable and Identifiable protocols, and imports the Foundation and FirebaseFirestoreSwift frameworks.

 The RecentMessage struct has the following properties:

 id: an optional String property that uses the @DocumentID property wrapper provided by the FirebaseFirestoreSwift framework.
 text: a String property that represents the message text.
 email: a String property that represents the email of the message sender.
 fromId: a String property that represents the unique identifier of the message sender.
 toId: a String property that represents the unique identifier of the message receiver.
 profileImageUrl: a String property that represents the URL of the sender's profile image.
 timestamp: a Date property that represents the time when the message was sent.
 The struct also has two computed properties:

 username: a String property that uses the components(separatedBy:) method to extract the username portion of the email address by splitting the string at the "@" character.
 timeAgo: a String property that uses the RelativeDateTimeFormatter class to format the timestamp as a relative date/time string.
 Overall, this code defines a struct that represents a recent chat message, including the sender's email, username, profile image URL, and the relative time the message was sent.
 */

import Foundation
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let text, email: String
    let fromId, toId: String
    let profileImageUrl: String
    let timestamp: Date
    
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

