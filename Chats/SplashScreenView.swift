//
//  SplashScreenView.swift
//  Chats
//
//  Created by Brad Bomkamp on 3/1/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var showMainView = false
    @State private var logoScale: CGFloat = 0.1

    var body: some View {
        VStack {
            Image("Logo")
                .scaleEffect(logoScale)
                .animation(.spring(response: 0.8, dampingFraction: 0.6))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    self.logoScale = 1.5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        self.logoScale = 0.8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation {
                            self.logoScale = 1.2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                self.logoScale = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.showMainView = true
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainMessagesView()
        }
    }
}
