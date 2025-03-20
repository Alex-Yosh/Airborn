//
//  DataChartView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-16.
//

import SwiftUI
import Charts

struct DataChartView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @State var data: [Double] = Array(repeating: 0.0, count: 24)
    let sensorType: Constants.dataTypes
    
    @State private var animatedData: [Double] = Array(repeating: 0.0, count: 24)
    @State private var showChart: Bool = false
    
    // MARK: - Generate Time Ranges
    private var dateRange: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Start at 12 AM
        
        switch dataManager.filterType {
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
    
    var body: some View {
        VStack {
            Chart {
                let chartData = zip(dateRange, animatedData.prefix(dateRange.count))
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
                    .foregroundStyle(colorCode(sensorType: sensorType))                }
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
                    values: dataManager.filterType == .lastDay ? .stride(by: .hour, count: 3) : .stride(by: .day, count: 1)
                ) { value in
                    if let date = value.as(Date.self) {
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: date)

                        AxisValueLabel {
                            VStack(alignment: .leading) {
                                if dataManager.filterType == .lastDay {
                                    switch hour {
                                    case 0, 12:
                                        Text(date, format: .dateTime.hour()) // Shows "12 AM" or "12 PM"
                                    default:
                                        Text(date, format: .dateTime.hour(.defaultDigits(amPM: .omitted))) // Shows "3, 6, 9, etc."
                                    }
                                    if value.index == 0 || hour == 0 {
                                        Text(date, format: .dateTime.month().day()) // Adds date under first or midnight tick
                                    }
                                } else {
                                    // For .last7Days: Show abbreviated weekday and date
                                    Text(date, format: .dateTime.weekday(.abbreviated))
                                    Text(date, format: .dateTime.month().day())
                                }
                            }
                        }

                        if hour == 0 || dataManager.filterType == .last7Days {
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
            .scaleEffect(showChart ? 1 : 0.9, anchor: .center) // Scale-up effect
            .animation(.spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.2), value: showChart) // Bounce effect
            
        }
        .onAppear {
            fetchData()
        }
        .onChange(of: dataManager.filterType) { _, _ in
            showChart = false
            data = Array(repeating: 0.0, count: 24)
            animatedData = Array(repeating: 0.0, count: 24)
            fetchData()
        }
    }
    
    private func fetchData() {
        dataManager.getUserAverages(type: sensorType) { result in
            DispatchQueue.main.async {
                self.data = result
                animateChart()
            }
        }
    }
    
    // MARK: - Animate Data Points & Line Together
    private func animateChart() {
        if !showChart {
            animatedData = [] // Reset before animation
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                withAnimation {
                    showChart = true
                }
            }
            
            for (index, value) in data.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(index) * 0.25) {
                    withAnimation {
                        animatedData.append(value) // Append values gradually
                    }
                }
            }
        }
    }
}

#Preview {
    DataChartView(sensorType: Constants.dataTypes.co2)
        .environmentObject(DataManager.shared)
}
