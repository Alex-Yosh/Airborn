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
    
    @State var data: [Double] = []
    let sensorType: Constants.dataTypes
    
    @State private var animatedData: [Double] = [] // Gradually added for animation
    @State private var showChart: Bool = false // Controls fade-in & scale animation
    
    private var last7DaysRange: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!
        return (0..<8).map { Calendar.current.date(byAdding: .day, value: -$0, to: tomorrow)! }.reversed()
    }
    
    
    func colorCode(sensorType: Constants.dataTypes) -> Color {
        switch sensorType {
        case .tvoc: return .purple
        case .co2: return .green
        default: return .blue
        }
    }
    
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d" // Removes leading zeros
            return formatter.string(from: date)
        }
    
    var body: some View {
        VStack {
            
            Chart {
                ForEach(Array(last7DaysRange.prefix(7).enumerated()), id: \.element) { index, date in
                    let value = index < animatedData.count ? animatedData[index] : 0.0 // Ensure correct alignment
                    
                    LineMark(
                        x: .value("Date", date),
                        y: .value(sensorType.rawValue, value)
                    )
                    .foregroundStyle(colorCode(sensorType: sensorType))
                    
                    PointMark(
                        x: .value("Date", date),
                        y: .value(sensorType.rawValue, value)
                    )
                    .foregroundStyle(colorCode(sensorType: sensorType))
                    
                    
                    RuleMark(x: .value("Date", date))
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .chartYAxis {
                AxisMarks(position: .trailing)
            }
            .chartYAxisLabel(position: .trailing, alignment: .center) {
                Text("\(sensorType.rawValue) (\(sensorType.metric))")
            }
            .chartYScale(domain: (data.min() ?? 0)...(data.max() ?? 500))
            .chartXScale(domain: last7DaysRange.first!...last7DaysRange.last!)
            .chartXAxis {
                AxisMarks(values: last7DaysRange) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(date, format: .dateTime.month(.defaultDigits).day(.defaultDigits))
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
    }
    
    private func fetchData() {
        dataManager.getLast7DayAverage(type: sensorType) { result in
            DispatchQueue.main.async {
                self.data = result // Update UI state with fetched data
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
                    showChart = true // Scale-in the entire chart
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
