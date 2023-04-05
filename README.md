# # Chat App for iOS

This is a simple chat app for iOS built using Swift and Firebase. The app allows users to log in or create an account, and then chat with other users who are also logged in.



https://user-images.githubusercontent.com/37642026/230232466-30833787-fedd-47ac-8a6e-44896777fbfd.mp4



## Dependencies

The app has two dependencies that need to be installed before the app can be run:

- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI.git)
- [Firebase iOS SDK](https://github.com/firebase/firebase-ios-sdk)

## Installation

To clone and run the app on your machine, follow these steps:

1. Clone the repository to your local machine:

```
git clone https://github.com/<your-username>/chat-app-ios.git
```


2. Install the dependencies using CocoaPods:

```
cd chat-app-ios
pod install
```


3. Open the `Chat.xcworkspace` file in Xcode.

4. Run the app on a simulator or on a physical device.

## Files

- **`FirebaseManager.swift`**: Defines a class called FirebaseManager that manages Firebase authentication, Firebase Storage, and Firestore database. It also defines a shared instance of FirebaseManager.
- **`LoginView.swift`**: Defines the login view of the app using SwiftUI. The view allows users to log in or create a new account, and also allows users to select a profile picture.
- **`MainMessagesView.swift`**: Defines the main messages view of the app using SwiftUI. It displays a list of recent messages, a custom navigation bar, and a new message button. The view also handles user sign out and navigation to the chat log view.
- **`CreateNewMessageView`.swift**: Defines the view for creating a new message. The view displays a list of users fetched from Firestore, allowing the user to select a recipient for a new chat message.


## Usage

To use the app, follow these steps:

1. Launch the app on your device or simulator.
2. Log in or create a new account.
3. Once logged in, you will see a list of chat rooms. Select a chat room to join.
4. In the chat room, you can send messages and view messages from other users who are also logged in.

## Future Work

- Allow users to create new chat rooms.
- Add support for sending images and other media in chat messages.
