//
//  MapView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    //TODO: add to some manager that recieves from database
    let exSensor = [SensorData(name: "name", lastUpdated: Date.now, lat: 43.873916, long: -79.243139, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 0.0, TVOC: 0.0, CO2: 0.0)]
    
    var body: some View {
        Map{
            ForEach(exSensor, id: \.self){ sensor in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: sensor.lat, longitude: sensor.long)){
                    MarkerView(sensor: sensor)
                }.annotationTitles(.hidden)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $mapManager.showSelectedSensor) {
            if let sensor = mapManager.selectedSensor{
                Text(sensor.name)
                    .presentationDetents([.medium, .large])
            }
            else{
                Text("Sensor not found")
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapManager.shared)
}
