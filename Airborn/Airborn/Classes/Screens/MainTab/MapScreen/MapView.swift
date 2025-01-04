//
//  MapView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position){
            ForEach(mapManager.sensors){ sensor in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: sensor.lat, longitude: sensor.long)){
                    MarkerView(sensor: sensor)
                }.annotationTitles(.hidden)
            }
            if let userlocation = mapManager.userLocation{
                Annotation("", coordinate: userlocation){
                    ZStack{
                        
                        Circle()
                            .frame(width: 32,height:32)
                            .foregroundColor(.blue.opacity(0.25))
                        
                        
                        Circle()
                            .frame(width: 20,height:20)
                            .foregroundColor(.white)
                        
                        
                        Circle()
                            .frame(width: 12,height:12)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .mapControls({
            MapUserLocationButton()
        })
        .onAppear {
            mapManager.checkAuthorization()
            if let loc = mapManager.userLocation{
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }else{
                position = .automatic
            }
        }
        .onChange(of: mapManager.selectedSensor){
            if mapManager.selectedSensor != nil{
                withAnimation {
                    position = .region(mapManager.region)
                }
            }
        }            .navigationBarHidden(true)
            .sheet(isPresented: $mapManager.showSelectedSensor, onDismiss: {mapManager.HideSensorSheet()}) {
                MapBottomSheetView()
                //                    .presentationDetents([.height((300))])
                //                    .presentationDragIndicator(.visible)
            }
    }
    
}

#Preview {
    MapView()
        .environmentObject(MapManager.shared)
}
