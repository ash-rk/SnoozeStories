//
//  LoginView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 13/04/2024.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var err : String = ""
    
    @Environment(\.colorScheme) var environmentColorScheme
    var customColorScheme: CustomColorScheme {
        environmentColorScheme == .dark ? .dark : .light
    }
    
    @AppStorage("auth_status") private var isAuthenticated: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text("Welcome to Snooze Stories")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.horizontal, 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 100)
            
            Image(systemName: "cloud.moon.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 144))
            
            VStack {
                SignInWithAppleButton(.signIn) { request in
                    let nonce = randomNonceString()
                    self.nonce = nonce
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        loginWithFireBase(authorization)
                    case .failure(let error):
                        showError(error.localizedDescription)
                    }
                }
                .frame(height: 45)
                .clipShape(.capsule)
                .padding(3)
                .background(Color.white)
                .clipShape(Capsule())
                .padding(.horizontal, 17)
//                .overlay {
//                    ZStack {
//                        Capsule()
//                        HStack {
//                            Image(systemName: "applelogo")
//                            Text("Sign in with Apple")
//                        }
//                        .foregroundStyle(colorScheme == .dark ? .black : .white)
//                    }
//                }
//                .allowsHitTesting(false)
            }

            HStack {
                VStack {
                    Divider()
                }
                Text("Or")
                VStack {
                    Divider()
                }
            }
            
            Button {
                Task {
                    do {
                        // Perform Google OAuth authentication
                        try await Authentication().googleOauth()
                    } catch {
                        // Handle errors - ensure this happens on the main thread
                        DispatchQueue.main.async {
                            // Assuming `err` is a @State variable for displaying errors
                            err = error.localizedDescription
                        }
                    }
                }
            } label: {
                HStack {
                    Image("google")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("Sign in with Google")
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(customColorScheme.subText2)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding(.horizontal, 17)
        }
        .alert(errorMessage, isPresented: $showAlert) {
            
        }
        .overlay {
            if isLoading {
                LoadingScreen()
            }
        }
    }
    
    // Loading Screen
    @ViewBuilder
    func LoadingScreen() -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        }
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    
    func loginWithFireBase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            isLoading = true
            
          guard let nonce else {
//            fatalError("Invalid state: A login callback was received, but no login request was sent.")
              showError("Invalid state: A login callback was received, but no login request was sent")
              return
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            showError("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            showError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error {
              // Error. If error.code == .MissingOrInvalidNonce, make sure
              // you're sending the SHA256-hashed nonce as a hex string with
              // your request to Apple.
              showError(error.localizedDescription)
            }
              //Successfully signed in
              isAuthenticated = true
              isLoading = false
          }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

#Preview {
    LoginView()
}
