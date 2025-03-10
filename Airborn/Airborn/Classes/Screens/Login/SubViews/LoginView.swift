//
//  LoginView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-07.
//

import SwiftUI

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            TextField("Username", text: $loginManager.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            TextField("Password", text: $loginManager.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding()

            if let errorMessage = loginManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                loginManager.login()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Button(action: {
                loginManager.switchToSignUpScreen()
            }) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}



#Preview {
    LoginView()
        .environmentObject(LoginManager.shared)
}
