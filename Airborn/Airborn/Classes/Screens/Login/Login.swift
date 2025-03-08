//
//  Login.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-07.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        if loginManager.signingUp{
            SignupView()
        }else{
            LoginView()
        }
    }
}

#Preview {
    Login()
}
