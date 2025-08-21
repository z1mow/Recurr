//
//  ContentView.swift
//  Recurr
//
//  Created by Şakir Yılmaz ÖĞÜT on 20.08.2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn = false
    
    var body: some View {
        Group {
            if isUserLoggedIn {
                MainView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            checkAuthState()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AuthStateChanged"))) { _ in
            checkAuthState()
        }
    }
    
    private func checkAuthState() {
        Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isUserLoggedIn = user != nil
            }
        }
    }
}

#Preview {
    ContentView()
}
