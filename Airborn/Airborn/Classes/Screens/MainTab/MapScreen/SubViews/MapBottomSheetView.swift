//
//  MapBottomSheetView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import SwiftUI

struct MapBottomSheetView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Text(mapManager.selectedSensor!.name)
            .presentationDetents([.medium, .large])
    }
}

#Preview {
    MapBottomSheetView()
}
