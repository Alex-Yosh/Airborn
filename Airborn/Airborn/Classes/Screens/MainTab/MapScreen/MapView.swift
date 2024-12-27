//
//  MapView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI
import MapKit

struct MapView: View {
    //TODO: add to some manager that recieves from database
    let exSensor = [SensorData(lastUpdated: Date.now, lat: 43.873916, long: -79.243139, battery: 100.0, temp: 21.0, humidity: 23.0, PM25: 0.0, TVOC: 0.0, CO2: 0.0)]
    
    var body: some View {
        Map{
            ForEach(exSensor, id: \.self){ sensor in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: sensor.lat, longitude: sensor.long)){
                    MarkerView(sensor: sensor)
                }.annotationTitles(.hidden)
            }
        }
    }
}

#Preview {
    MapView()
}
