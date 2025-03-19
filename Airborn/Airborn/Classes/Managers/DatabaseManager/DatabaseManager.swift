//
//  DatabaseManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import Foundation
import SwiftUI
import Combine

class DatabaseManager: ObservableObject {
    
    static var shared = DatabaseManager()
    
    let baseURL = "https://airborne-897502924648.northamerica-northeast1.run.app/api"
    
    private init() {}
    
    var lastestDataCancellables = Set<AnyCancellable>()
}
