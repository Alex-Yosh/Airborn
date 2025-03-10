import SwiftUI

struct HomeTableView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack {
            Text("Recent Reading")
                .textStyle(SubHeadingTextStyle())
            
            ZStack {
                RoundedRectangle(cornerRadius: 34)
                    .fill(Constants.Colour.PrimaryGreen.opacity(0.4))
                
                if let sensorData = dataManager.latestSensorData {
                    VStack {
                        Grid {
                            GridRow {
                                Text("Metric")
                                Text("Quality")
                            }
                            .padding(.vertical, 8)
                            
                            Divider()
                            
                            SensorRow(metric: Constants.dataTypes.pm25.rawValue, quality: sensorData.getQualityText(ofType: Constants.dataTypes.pm25))
                            SensorRow(metric: Constants.dataTypes.tvoc.rawValue, quality: sensorData.getQualityText(ofType: Constants.dataTypes.tvoc))
                            SensorRow(metric: Constants.dataTypes.co2.rawValue, quality: sensorData.getQualityText(ofType: Constants.dataTypes.co2))
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                // Handle "See More" navigation
                            }) {
                                Text("See More")
                                    .textStyle(RegularTextStyle())
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    // Show loading indicator while data is being fetched
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                        Text("Loading data...")
                            .textStyle(RegularTextStyle())
                    }
                }
            }
            .frame(height: 250)
            .padding(.horizontal, 32)
        }
    }
}

struct SensorRow: View {
    let metric: String
    let quality: String
    
    var body: some View {
        GridRow {
            Text(metric)
            Text(quality)
        }
        .padding(.vertical, 8)
        Divider()
    }
}

#Preview {
    HomeTableView()
        .environmentObject(DataManager.shared)
}
