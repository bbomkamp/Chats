//
//  ContentView.swift
//  Chats
//
//  Created by Brad Bomkamp on 2/24/23.
//

import SwiftUI
import Firebase


struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
   
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")){
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if !isLoginMode {
                        Button {
                            
                        } label : {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                   
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                   
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight:.semibold))
                            Spacer()
                        }.background(Color.blue)
                        
                    }
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
            .ignoresSafeArea())
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
//            print("Should log into Firebase with existing credentials")
        } else {
            createNewAccount()
            }
//            print("Register a new account inside of Firebase Auth and then store image in Storage somehow...")
        }
    
    @State var loginStatusMessage = ""
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user: ", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to loging user: ", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            print("Successfully Logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
