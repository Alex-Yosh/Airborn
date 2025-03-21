//
//  MapChartView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-21.
//

import SwiftUI
import Charts

struct MapChartView: View {
    
    @EnvironmentObject var mapManager: MapManager
    @EnvironmentObject var dataManager: DataManager
    
    @State var data: [Double] = []
    let sensorType: Constants.dataTypes
    
    @State private var showChart: Bool = false
    
    // MARK: - Generate Time Ranges
    private var dateRange: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Start at 12 AM
        
        switch mapManager.filterType {
        case .lastDay:
            return (0..<24).compactMap { hour in
                calendar.date(bySettingHour: hour, minute: 0, second: 0, of: today)
            }
        case .last7Days:
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            return (0..<8).map { calendar.date(byAdding: .day, value: -$0, to: tomorrow)! }.reversed()
        }
    }
    
    func colorCode(sensorType: Constants.dataTypes) -> Color {
        switch sensorType {
        case .tvoc: return .purple
        case .co2: return .green
        default: return .blue
        }
    }
    
    private var prefix: Int {
        return mapManager.filterType == .lastDay ? 24 : 7
    }
    
    var body: some View {
        VStack {
            Chart {
                let chartData = zip(dateRange, data.prefix(prefix))
                    .map { ($0, $1) } // Precompute
                
                ForEach(chartData, id: \.0) { (time, value) in
                    LineMark(
                        x: .value("Time", time),
                        y: .value(sensorType.rawValue, value)
                    )
                    .foregroundStyle(colorCode(sensorType: sensorType))
                    
                    PointMark(
                        x: .value("Time", time),
                        y: .value(sensorType.rawValue, value)
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
            .chartYScale(domain: (data.min() ?? 1) ... (data.max() ?? 10)+1)
            .chartXScale(domain: dateRange.first!...dateRange.last!)
            .chartXAxis {
                AxisMarks(
                    values: mapManager.filterType == .lastDay ? .stride(by: .hour, count: 3) : .stride(by: .day, count: 1)
                ) { value in
                    if let date = value.as(Date.self) {
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: date)

                        AxisValueLabel {
                            VStack(alignment: .leading) {
                                if mapManager.filterType == .lastDay {
                                    switch hour {
                                    case 0, 12:
                                        Text(date, format: .dateTime.hour())
                                    default:
                                        Text(date, format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                                    }
                                } else {
                                    Text(date, format: .dateTime.weekday(.abbreviated))
                                    Text(date, format: .dateTime.month())
                                    Text(date, format: .dateTime.day())
                                }
                            }
                        }

                        if hour == 0 || mapManager.filterType == .last7Days {
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                        } else {
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
            }
            .frame(height: 300)
            .opacity(showChart ? 1 : 0) // Fade-in effect
            .animation(.easeIn(duration: 0.5), value: showChart) // Simple animation
            
        }
        .onAppear {
            if data.isEmpty || !showChart {
                fetchData()
            }
        }
        .onChange(of: mapManager.filterType) { _, _ in
            showChart = false
            fetchData()
        }
    }
    
    private func fetchData() {
        if let sensor = mapManager.detailSensor{
            dataManager.getSensorAverages(type: sensorType, sensor: sensor) { result in
                DispatchQueue.main.async {
                    self.data = result
                    showChart = true
                }
            }
        }
    }
}

#Preview {
    MapChartView( sensorType: .co2)
        .environmentObject(MapManager.shared)
        .environmentObject(DataManager.shared)
}
