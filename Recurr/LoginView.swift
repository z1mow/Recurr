//
//  LoginView.swift
//  Recurr
//
//  Created by Şakir Yılmaz ÖĞÜT on 20.08.2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with gradient background - SABIT KALACAK
            VStack(spacing: 8) {
                // App logo/icon placeholder
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.green.opacity(0.8), .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "repeat.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    )
                    .padding(.bottom, 20)
                
                // Dinamik içerik için ZStack kullanarak smooth transition
                ZStack {
                    VStack(spacing: 8) {
                        Text("Hoş Geldiniz")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Hesabınıza giriş yapın")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .opacity(isLoginMode ? 1 : 0)
                    
                    VStack(spacing: 8) {
                        Text("Hesap Oluşturun")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Yeni hesabınızı oluşturun")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .opacity(isLoginMode ? 0 : 1)
                }
                .animation(.easeInOut(duration: 0.3), value: isLoginMode)
            }
            .padding(.top, 32)
            .padding(.bottom, 48)
            
            // Form Fields with modern styling - SABIT KALACAK
            VStack(spacing: 20) {
                // Email Field - SABIT
                VStack(alignment: .leading, spacing: 8) {
                    Text("E-posta")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.green)
                            .frame(width: 20)
                        
                        TextField("ornek@email.com", text: $email)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(email.isEmpty ? Color.clear : Color.green.opacity(0.5), lineWidth: 1)
                            )
                    )
                }
                
                // Password Field - SABIT (sadece placeholder değişecek)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Şifre")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.green)
                            .frame(width: 20)
                        
                        // Placeholder dinamik ama field sabit kalacak
                        ZStack(alignment: .leading) {
                            SecureField("Şifrenizi girin", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .opacity(isLoginMode ? 1 : 0)
                            
                            SecureField("En az 6 karakter", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .opacity(isLoginMode ? 0 : 1)
                        }
                        
                        Button(action: {
                            // Şifre görünürlük toggle - şimdilik boş
                        }) {
                            Image(systemName: "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(password.isEmpty ? Color.clear : Color.green.opacity(0.5), lineWidth: 1)
                            )
                    )
                }
            }
            .padding(.horizontal, 24)
            
            // Forgot Password Link
            if isLoginMode {
                HStack {
                    Spacer()
                    Button("Şifremi Unuttum") {
                        // Forgot password logic
                        forgotPassword()
                    }
                    .foregroundColor(.green)
                    .font(.system(size: 14))
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
            }
            
            // Login Button with modern gradient - SABIT ŞEKİL
            Button(action: {
                if isLoginMode {
                    loginUser()
                } else {
                    registerUser()
                }
            }) {
                // Buton içeriği dinamik ama buton kendisi sabit
                ZStack {
                    // Loading state
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        // Login mode content
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 16))
                            Text("Giriş Yap")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .opacity(isLoginMode ? 1 : 0)
                        
                        // Register mode content
                        HStack {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .font(.system(size: 16))
                            Text("Kayıt Ol")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .opacity(isLoginMode ? 0 : 1)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [.green.opacity(0.8), .green],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 30)
            .disabled(isLoading)
            .scaleEffect(isLoading ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isLoading)
            
            // Or Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                Text("veya")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Apple Sign In Button (Disabled for now) with modern styling
            Button(action: {
                // Apple Sign In - şimdilik disabled
            }) {
                HStack {
                    Image(systemName: "applelogo")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    
                    Text("Apple ile Giriş Yap")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray4), lineWidth: 1.5)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .disabled(true) // Apple Sign In şimdilik disabled
            .opacity(0.6)
            
            Spacer()
            
            // Toggle between Login/Register with modern styling - SABIT KONUM
            HStack {
                // Dinamik metin ama konum sabit
                ZStack {
                    Text("Hesabınız yok mu?")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                        .opacity(isLoginMode ? 1 : 0)
                    
                    Text("Zaten hesabınız var mı?")
                        .foregroundColor(.secondary)
                        .font(.system(size: 15))
                        .opacity(isLoginMode ? 0 : 1)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLoginMode.toggle()
                    }
                    // Clear fields when switching - kaldırıldı, alanlar sabit kalacak
                }) {
                    ZStack {
                        Text("Hesap oluştur")
                            .underline(true)
                            .foregroundColor(.green)
                            .font(.system(size: 15, weight: .semibold))
                            .opacity(isLoginMode ? 1 : 0)
                        
                        Text("Giriş yap")
                            .underline(true)
                            .foregroundColor(.green)
                            .font(.system(size: 15, weight: .semibold))
                            .opacity(isLoginMode ? 0 : 1)
                    }
                }
            }
            .padding(.bottom, 32)
        }
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .alert("Bilgi", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Auth Functions
    
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun")
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                showAlert(message: "Giriş hatası: \(error.localizedDescription)")
                return
            }
            
            // Successful login - will be handled by ContentView
        }
    }
    
    func registerUser() {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(message: "Şifre en az 6 karakter olmalıdır")
            return
        }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            
            if let error = error {
                showAlert(message: "Kayıt hatası: \(error.localizedDescription)")
                return
            }
            
            // Successful registration - will be handled by ContentView
        }
    }
    
    func forgotPassword() {
        guard !email.isEmpty else {
            showAlert(message: "Lütfen önce email adresinizi girin")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                showAlert(message: "Şifre sıfırlama hatası: \(error.localizedDescription)")
            } else {
                showAlert(message: "Şifre sıfırlama linki email adresinize gönderildi")
            }
        }
    }
    
    func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    LoginView()
}
