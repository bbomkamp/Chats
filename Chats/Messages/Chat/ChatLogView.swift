//
//  ChatLogView.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//

import SwiftUI //importing the SwiftUI framework
import Firebase //importing the Firebase framework

class ChatLogViewModel: ObservableObject { //creating a class called ChatLogViewModel that conforms to the ObservableObject protocol
    
    @Published var chatText = "" //a published property called chatText, which is a string
    @Published var errorMessage = "" //a published property called errorMessage, which is a string
    
    @Published var chatMessages = [ChatMessage]() //a published property called chatMessages, which is an array of ChatMessage structs
    
    var chatUser: ChatUser? //a property called chatUser, which is an optional ChatUser struct
    
    init(chatUser: ChatUser?) { //a required initializer that takes an optional ChatUser struct
        self.chatUser = chatUser //sets the value of the chatUser property to the passed ChatUser struct
        
        fetchMessages() //calls the fetchMessages method
    }
    
    var firestoreListener: ListenerRegistration? //a property called firestoreListener, which is an optional ListenerRegistration
    
    func fetchMessages() { //a method called fetchMessages
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return } //gets the current user's uid from Firebase if it exists, else returns
        guard let toId = chatUser?.uid else { return } //gets the uid of the chatUser if it exists, else returns
        firestoreListener?.remove() //removes the Firestore listener if it exists
        chatMessages.removeAll() //removes all objects from the chatMessages array
        firestoreListener = FirebaseManager.shared.firestore //sets the firestoreListener property to Firebase Firestore
            .collection(FirebaseConstants.messages) //gets a collection reference to the 'messages' collection
            .document(fromId) //gets a document reference to the current user's uid
            .collection(toId) //gets a collection reference to the chatUser's uid
            .order(by: FirebaseConstants.timestamp) //orders the messages by their timestamp
            .addSnapshotListener { querySnapshot, error in //starts a snapshot listener to listen for changes to the messages collection
                if let error = error { //if there is an error
                    self.errorMessage = "Failed to listen for messages: \(error)" //sets the errorMessage property to the error message
                    print(error) //prints the error message to the console
                    return //exits the method
                }
                
                querySnapshot?.documentChanges.forEach({ change in //loops through each document change in the query snapshot
                    if change.type == .added { //if the change is of type 'added'
                        do {
                            if let cm = try? change.document.data(as: ChatMessage.self) { //tries to decode the document data into a ChatMessage struct
                                self.chatMessages.append(cm) //appends the decoded ChatMessage struct to the chatMessages array
                                print("Appending chatMessage in ChatLogView: \(Date())") //prints a message to the console
                            }
                        }
                    }
                })
                
                DispatchQueue.main.async { //dispatches the following code block onto the main thread
                    self.count += 1 //increments the count property by 1
                }
            }
    }
    
    // Define a function to handle sending a chat message
    func handleSend() {
        // Print the chat text to the console
        print(chatText)
        // Get the current user's ID from Firebase authentication
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        // Get the ID of the chat recipient
        guard let toId = chatUser?.uid else { return }
        
        // Create a Firestore document for the message
        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        // Create a ChatMessage object with the message details
        let msg = ChatMessage(id: "", fromId: fromId, toId: toId, text: chatText, timestamp: Date())

        // Save the message data to Firestore
        try? document.setData(from: msg) { error in
            if let error = error {
                // If there was an error, set an error message and return
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            // If the message was saved successfully, print a success message to the console
            print("Successfully saved current user sending message")
            
            // Save the recent message data for the current user and recipient
            self.persistRecentMessage()
            
            // Reset the chat text and increment the count of sent messages
            self.chatText = ""
            self.count += 1
        }
        
        // Create a Firestore document for the recipient's message data
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        // Save the message data to Firestore for the recipient as well
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                // If there was an error, set an error message and return
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            // If the message was saved successfully, print a success message to the console
            print("Recipient saved message as well")
        }
    }

    // Define a function to persist recent message data for the current user and recipient
    private func persistRecentMessage() {
        // Get the chat user and current user IDs from Firebase authentication
        guard let chatUser = chatUser else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        // Create a Firestore document for the recent message data for the current user
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        // Create a dictionary of data for the recent message
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // Save the recent message data to Firestore for the current user
        document.setData(data) { error in
            if let error = error {
                // If there was an error, set an error message and print an error message to the console
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    @Published var count = 0
}

struct ChatLogView: View {

    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())
                }
            } else {
                
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
