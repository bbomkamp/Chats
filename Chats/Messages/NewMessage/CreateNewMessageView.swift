//
//  NewMessageView.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/28/23.
//
/**
 This code defines a view model and a view for creating a new message in a chat application.

 The CreateNewMessageViewModel is an ObservableObject that has two @Published properties: users, an array of ChatUser objects, and errorMessage, a string that contains an error message if there is any issue fetching users from the Firebase database.

 In the init() method, the fetchAllUsers() method is called to fetch all the users from the Firebase Firestore database. The fetch() method is called on the FirebaseManager object, which retrieves a collection of documents from the users collection in Firestore. The closure passed to the getDocuments() method is called once the documents are retrieved. If there is an error, the errorMessage property is set to an appropriate message. Otherwise, the closure loops through the documents and tries to convert each one to a ChatUser object using the snapshot.data(as: ChatUser.self) method. If a ChatUser object is successfully created, it is added to the users array, as long as it's not the current user.

 The NewMessageView is a View that displays a list of users and allows the user to select a user to create a new message with. The view model for this view is an instance of CreateNewMessageViewModel. The didSelectNewUser property is a closure that takes a ChatUser object and returns nothing. It is called when the user selects a user from the list. The presentationMode property is used to dismiss the view when the user selects a user.

 The body of the view consists of a ScrollView that contains a Text view to display the errorMessage, followed by a ForEach loop that displays the list of users. The user's profile image and email are displayed in a HStack. When the user taps on a user, the didSelectNewUser closure is called with the selected user as the argument.

 Finally, there is a NewMessageView_Previews struct that previews the MainMessagesView.
 */

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
                    
                })
            }
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 2)
                                )
                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
    }
}


struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a preview of the view
        MainMessagesView()
    }
}
