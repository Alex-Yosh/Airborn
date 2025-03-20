//
//  DataLastDayChartView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import SwiftUI
import Charts

struct LastDayChartView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @State var data: [Double] = []
    let sensorType: Constants.dataTypes
    
    @State private var animatedData: [Double] = []
    @State private var showChart: Bool = false
    
    // MARK: - Generate Hourly Range for Today
    private var hourlyRange: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<24).compactMap { calendar.date(byAdding: .hour, value: $0, to: today) }
    }
    
    private var xAxisLabels: [Date] {
        let calendar = Calendar.current
        return hourlyRange.filter { date in
            let hour = calendar.component(.hour, from: date)
            return hour % 3 == 0
        }
    }
    
    private var formattedLabels: [Date: String] {
        var labels = [Date: String]()
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // ✅ Proper AM/PM format
        
        for date in xAxisLabels {
            labels[date] = formatter.string(from: date)
        }
        return labels
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
                let chartData = zip(hourlyRange, animatedData.prefix(hourlyRange.count)).map { ($0, $1) } // Reduce compiler load
                
                ForEach(chartData, id: \.0) { (hour, value) in
                    LineMark(
                        x: .value("Hour", hour),
                        y: .value(sensorType.rawValue, value)
                    )
                    .foregroundStyle(colorCode(sensorType: sensorType))
                    
                    PointMark(
                        x: .value("Hour", hour),
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
            .chartYScale(domain: (data.min() ?? 0)...(data.max() ?? 500))
            .chartXScale(domain: hourlyRange.first!...hourlyRange.last!)
            .chartXAxis {
                AxisMarks(values: xAxisLabels) { value in
                    if let date = value.as(Date.self), let label = formattedLabels[date] {
                        AxisValueLabel {
                            Text(label)
                        }
                    }
                }
            }
            .frame(height: 300)
            .opacity(showChart ? 1 : 0)
            .scaleEffect(showChart ? 1 : 0.9, anchor: .center)
            .animation(.spring(response: 1.2, dampingFraction: 0.8, blendDuration: 0.2), value: showChart)
        }
        .onAppear {
            fetchData()
        }
        .onChange(of: dataManager.filterType) { _, _ in
            fetchData()
        }
    }
    
    // MARK: - Fetch Hourly Data for Today
    private func fetchData() {
        dataManager.getUserAverages(type: sensorType) { result in
            DispatchQueue.main.async {
                updateChartData(with: result)
            }
        }
    }
    
    // MARK: - Update Data with Animation
    private func updateChartData(with newData: [Double]) {
        guard !newData.isEmpty else { return }
        
        self.data = newData
        animatedData = []
        
        withAnimation {
            showChart = true
        }
        
        for (index, value) in newData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 + Double(index) * 0.1) {
                animatedData.append(value)
            }
        }
    }
}

#Preview {
    LastDayChartView(sensorType: Constants.dataTypes.co2)
        .environmentObject(DataManager.shared)
}

