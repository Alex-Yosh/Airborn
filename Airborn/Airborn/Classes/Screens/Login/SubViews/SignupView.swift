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
                .font(.largeTitle)
                .bold()
            
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

            Button(action: {
                loginManager.signup()
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

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
}
