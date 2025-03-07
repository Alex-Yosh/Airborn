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
    
    @Published var username: String = ""
    @Published var password: String = ""
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
}

