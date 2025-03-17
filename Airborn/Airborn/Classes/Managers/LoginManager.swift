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
    
    init() {
        if let savedUUIDString = UserDefaults.standard.string(forKey: "user_id"),
           let savedUUID = UUID(uuidString: savedUUIDString) {
            self.goToApp(uuid: savedUUID)
        }
    }
    

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
                    self.goToApp(uuid: loginResponse.user_id)
                    
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
                    self.goToApp(uuid: signupResponse.id)
                    
                case .failure(_):
                    self.errorMessage = "Failed to Sign up"
                    return
                }
            }
        }
    }
    
    func goToApp(uuid: UUID)
    {
        // Store user ID in UserDefaults
        UserDefaults.standard.set(uuid.uuidString, forKey: "user_id")
        UserDefaults.standard.synchronize() // Ensures data is saved immediately
        
        self.uuid = uuid
        //navigate to loading
        NavigationManager.shared.appStatus.send(.loading)
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

