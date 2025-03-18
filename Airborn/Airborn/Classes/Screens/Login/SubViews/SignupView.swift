//
//  SignupView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-07.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .textStyle(LoginTextStyle())
            
            TextField("Username", text: $loginManager.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $loginManager.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let errorMessage = loginManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if loginManager.isLoading {
                ProgressView()
                    .padding()
            }

            LongButtonView(title: "Sign Up", systemImage: "", backgroundColor: Color.green, action: {
                loginManager.signup()
            })

            Button(action: {
                loginManager.backToLoginScreen()
            }) {
                Text("Already have an account? Log in")
                    .foregroundColor(.blue)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}


#Preview {
    SignupView()
        .environmentObject(LoginManager.shared)
}
