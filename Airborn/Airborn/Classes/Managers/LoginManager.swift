//
//  LoginManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-07.
//

import Foundation
import SwiftUI

class LoginManager: ObservableObject {
    
    static var shared = LoginManager()
    
    @Published var signingUp: Bool = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var uuid: UUID?

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty"
            return
        }

        errorMessage = nil
        DatabaseManager.shared.loginUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loginResponse):
                    self.uuid = loginResponse.user_id
                    NavigationManager.shared.appStatus.send(.loading)
                    
                case .failure(_):
                    self.errorMessage = "Invalid Credentials"
                    return
                }
            }
        }
    }
    
    func signup() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        DatabaseManager.shared.signupUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let signupResponse):
                    self.uuid = signupResponse.id
                    NavigationManager.shared.appStatus.send(.loading)
                    
                case .failure(_):
                    self.errorMessage = "Failed to Sign up"
                    return
                }
            }
        }
    }
    
    func switchToSignUpScreen(){
        username = ""
        password = ""
        errorMessage = nil
        signingUp = true
    }
    
    func backToLoginScreen(){
        username = ""
        password = ""
        errorMessage = nil
        signingUp = false
    }
}

