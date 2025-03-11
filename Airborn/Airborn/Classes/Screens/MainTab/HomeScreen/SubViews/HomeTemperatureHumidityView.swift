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
                Image(systemName: thermometerImage(for: temperature))
                    .font(.system(size: 32))
                    .foregroundColor(.black)
                Text("\(Int(temperature))°C")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
            }
            Spacer()

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
    }
}

func thermometerImage(for temperature: Double) -> String {
    switch temperature {
    case ..<0:
        return "thermometer.snowflake"
    case 0..<10:
        return "thermometer.low"
    case 10..<25:
        return "thermometer.medium"
    case 25..<35:
        return "thermometer.high"
    default:
        return "thermometer.sun"
    }
}


#Preview {
    TemperatureHumidityView(temperature: 2, humidity: 2)
}
