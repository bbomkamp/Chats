//
//  ChatUser.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//
/**
 This code defines a Swift struct called ChatUser that conforms to the Codable and Identifiable protocols. It has three properties: uid, email, and profileImageUrl, all of which are of type String. The @DocumentID property wrapper is used to mark the id property as the document ID in Firestore. */


import FirebaseFirestoreSwift // Import the FirebaseFirestoreSwift framework.

struct ChatUser: Codable, Identifiable { // Define a struct called ChatUser that conforms to Codable and Identifiable protocols.
    @DocumentID var id: String? // Use the @DocumentID property wrapper to mark this property as the document ID in Firestore.
    let uid, email, profileImageUrl: String // Define three properties for ChatUser: uid, email, and profileImageUrl.
}
