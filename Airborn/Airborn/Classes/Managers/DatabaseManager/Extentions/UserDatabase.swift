//
//  UserDatabase.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import Foundation

extension DatabaseManager {
    
    /// Generic function to fetch daily averages for last 7 days
    func getUserWeekAverages(type: Constants.apiAveragesEndpoint, completion: @escaping ([Double]) -> Void) {
        guard let userId = LoginManager.shared.uuid else {
            completion([]) // Return empty array if user is not logged in
            return
        }
        
        guard let url = URL(string: "\(baseURL)/data/\(type.rawValue)/avg/user/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let key = "\(type.rawValue)_daily_averages"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let sortedAverages = (jsonResponse?[key] as? [[String: Any]])?
                    .compactMap { item -> (date: Date, value: Double)? in
                        guard let dateString = item["date"] as? String,
                              let value = item["average_\(type.rawValue)"] as? Double,
                              let date = dateFormatter.date(from: dateString) else { return nil }
                        return (date, value)
                    }
                    .sorted { $0.date < $1.date }
                    .map { $0.value } ?? []
                
                completion(sortedAverages)
            } catch {
                completion([])
            }
        }.resume()
    }
    
    /// Generic function to fetch hourly averages for a given day
    func getUserDayAverages(type: Constants.apiAveragesEndpoint, completion: @escaping ([Double]) -> Void) {
        guard let userId = LoginManager.shared.uuid else {
            completion([]) // Return empty array if user is not logged in
            return
        }
        
        guard let url = URL(string: "\(baseURL)/data/\(type.rawValue)/hourly/user/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let key = "\(type.rawValue)_hourly_averages"
                
                let dateFormatter = ISO8601DateFormatter()
                
                let sortedAverages = (jsonResponse?[key] as? [[String: Any]])?
                    .compactMap { item -> (date: Date, value: Double)? in
                        guard let hourString = item["hour"] as? String,
                              let value = item["avg_\(type.rawValue)"] as? Double,
                              let date = dateFormatter.date(from: hourString) else { return nil }
                        return (date, value)
                    }
                    .sorted { $0.date < $1.date }
                    .map { $0.value } ?? []
                
                completion(sortedAverages)
                
            } catch {
                completion([])
            }
        }.resume()
    }
}

