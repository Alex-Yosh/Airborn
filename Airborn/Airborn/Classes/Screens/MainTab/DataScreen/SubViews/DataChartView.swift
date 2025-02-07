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
    let sensorType: Constants.dataTypes
    
    // Generate a fixed range for the last 7 days
    private var last7DaysRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        return (0..<8).map { Calendar.current.date(byAdding: .day, value: -$0, to: tomorrow)! }.reversed()
    }
    
    // Filter sensor data for the last 7 days
    private var last7DaysData: [SensorData] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sensorData
            .filter { ($0.date ?? Date()) >= sevenDaysAgo }
            .sorted { ($0.date ?? Date() < ($1.date ?? Date()))}
    }
    
    func colorCode(sensorType: Constants.dataTypes) -> Color{
        switch sensorType {
            
        case .tvoc:
            return .purple
            
        case .co2:
            return .green
            
        default:
            return .blue
        }
    }
    
    
    var body: some View {
        Chart {
            // Add LineMark and PointMark only for available data
            ForEach(last7DaysData, id: \.id) { data in
                
                LineMark(
                    x: .value("Date", data.date ?? Date()),
                    y: .value(sensorType.rawValue, data.temperature)
                )
                .foregroundStyle(colorCode(sensorType: sensorType))
                
                PointMark(
                    x: .value("Date", data.date ?? Date()),
                    y: .value(sensorType.rawValue, data.temperature)
                )
                .foregroundStyle(colorCode(sensorType: sensorType))
                
            }
            
            
        }
        .chartYAxis {
            AxisMarks(position: .trailing)
        }
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("\(sensorType.rawValue) (\(sensorType.metric))")
        }
        .chartXScale(domain: last7DaysRange.first!...last7DaysRange.last!)
        .chartXAxis {
            AxisMarks(values: last7DaysRange) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date, format: .dateTime.month().day())
                    }
                }
            }
        }
        .padding()
        .frame(height: 300)
    }
}

#Preview {
    DataChartView(sensorData: [
        SensorData(id: UUID(), sensorId: UUID(), temperature: 20.5, humidity: 50, pm25: 10, tvoc: 1, co2: 400, date: Date()),
        SensorData(id: UUID(), sensorId: UUID(), temperature: 22.3, humidity: 46, pm25: 8, tvoc: 1.1, co2: 410, date: Date().addingTimeInterval(-480000)),
        SensorData(id: UUID(), sensorId: UUID(), temperature: 21.0, humidity: 48, pm25: 15, tvoc: 1.2, co2: 420, date: Date().addingTimeInterval(-360000))
    ], sensorType: Constants.dataTypes.pm25)
}
