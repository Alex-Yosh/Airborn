//
//  HomeTemperatureHumidityView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-10.
//

import SwiftUI

struct TemperatureHumidityView: View {
    var temperature: Double
    var humidity: Double

    var body: some View {
        HStack(spacing: 24) {
            // Temperature
            HStack {
                Image(systemName: "thermometer")
                    .font(.system(size: 32))
                    .foregroundColor(.black)
                Text("\(Int(temperature))°C")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
            }

            // Humidity
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.black)
                Text("\(Int(humidity))%")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Constants.Colour.GrayishWhite)
        .cornerRadius(12)
        .padding()
    }
}

// Preview
struct ContentView: View {
    var body: some View {
        TemperatureHumidityView(temperature: 23, humidity: 34)
            .padding()
    }
}

#Preview {
    ContentView()
}
