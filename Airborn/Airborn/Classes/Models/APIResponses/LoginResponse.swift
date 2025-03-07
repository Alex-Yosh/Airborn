//
//  LoginResponse.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-07.
//

import Foundation

struct LoginResponse: Codable {
    let message: String
    let user_id: UUID
}
