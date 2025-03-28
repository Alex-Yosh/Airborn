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
        if mapManager.showDetails{
            
            ZStack{
                Constants.Colour.SecondaryLightGray.ignoresSafeArea()
                ScrollViewReader { proxy in
                    ScrollView{
                        MapDataDetailView()
                            .navigationTitle(mapManager.detailSensor?.name ?? "")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Back") {
                                        mapManager.detailSensor = nil
                                        mapManager.showDetails = false
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    DataFilterDropdownMenu(forMap: true)
                                }
                            }
                            .onAppear {
                                proxy.scrollTo("top", anchor: .top) // Reset scroll when reopened
                            }
                    }
                }
            }
            
        }else{
            Map(position: $position){
                ForEach(mapManager.sensors){ sensor in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: sensor.latitude, longitude: sensor.longitude)){
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
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .mapControls({
                if (mapManager.userLocation != nil){
                    MapUserLocationButton()
                }
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
            .onChange(of: mapManager.bottomSheetSensor){
                if mapManager.bottomSheetSensor != nil{
                    withAnimation {
                        position = .region(mapManager.region)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $mapManager.showSelectedSensor, onDismiss: {mapManager.HideSensorSheet()}) {
                MapBottomSheetView()
                    .presentationDetents([.medium]) // Only take half the screen
                    .presentationDragIndicator(.visible) // Add drag indicator
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(MapManager.shared)
}
