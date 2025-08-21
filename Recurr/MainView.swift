//
//  MainView.swift
//  Recurr
//
//  Created by Şakir Yılmaz ÖĞÜT on 20.08.2025.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 60))
                
                Text("Başarıyla Giriş Yaptınız!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Auth sistemi çalışıyor!")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                // Logout Button for testing
                Button("Çıkış Yap") {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Sign out error: \(error.localizedDescription)")
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.2))
                .cornerRadius(8)
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}
