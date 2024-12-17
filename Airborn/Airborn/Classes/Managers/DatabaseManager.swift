//
//  DatabaseManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-16.
//

import Foundation
import SwiftUI

class DatabaseManager: ObservableObject {
    
    static var shared = DatabaseManager()
    
    func fetchDataFromFlask() {
        // Replace with your Flask server's URL
        guard let url = URL(string: "http://127.0.0.1:5000/data") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Decode JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response JSON: \(json)")
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}
