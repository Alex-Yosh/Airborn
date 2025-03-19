//
//  MapDatabase.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import Foundation

extension DatabaseManager{
    /// Fetches address details 
    func fetchAddressFromCoordinates(latitude: Double, longitude: Double) async -> Address? {
        let urlString = "https://nominatim.openstreetmap.org/reverse?format=json&lat=\(latitude)&lon=\(longitude)&addressdetails=1"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(NominatimResponse.self, from: data)
            
            // Convert API response to AddressModel
            return Address(
                house_number: decodedResponse.address.house_number,
                road: decodedResponse.address.road,
                building: decodedResponse.address.building,
                university: decodedResponse.address.university
            )
        } catch {
            return nil
        }
    }
}
