//
//  DataChartView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-16.
//

import SwiftUI
import Charts

struct DataChartView: View {
    @State var data: [Double]
    
    var body: some View {
        Text("filler")
//        Chart {
//            ForEach(departmentAProfit, id: \.date) { item in
//                LineMark(
//                    x: .value("Date", item.date),
//                    y: .value("Profit A", item.profit),
//                    series: .value("Company", "A")
//                )
//                .foregroundStyle(.blue)
//            }
//            ForEach(departmentBProfit, id: \.date) { item in
//                LineMark(
//                    x: .value("Date", item.date),
//                    y: .value("Profit B", item.profit),
//                    series: .value("Company", "B")
//                )
//                .foregroundStyle(.green)
//            }
//            RuleMark(
//                y: .value("Threshold", 400)
//            )
//            .foregroundStyle(.red)
//        })
    }
}

#Preview {
    DataChartView(data: [])
}
