//
//  DataChartView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-16.
//

import SwiftUI
import Charts

struct DataChartView: View {
    let sensorData: [SensorData] // Array of sensor data to plot
    
    var body: some View {
        Chart(sensorData) { data in
            LineMark(
                x: .value("Date", data.date ?? Date()),
                y: .value("Temperature", data.temperature)
            )
            .foregroundStyle(.blue)
            .interpolationMethod(.catmullRom) // Smooth the line
        }
        .chartYAxis {
            AxisMarks(position: .leading) // Y-axis on the left
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel(format: .dateTime.month().day()) // Format X-axis labels
                }
            }
        }
        .padding()
        .frame(height: 300)
        .navigationTitle("Sensor Data")
    }
}

#Preview {
    DataChartView(sensorData: [
        SensorData(sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
        SensorData(sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-3600)),
        SensorData(sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-7200))
    ])
}
