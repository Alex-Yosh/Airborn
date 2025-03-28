//
//  DataFilterDropdownMenu.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-19.
//

import SwiftUI

struct DataFilterDropdownMenu: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var mapManager: MapManager
    
    var forMap:Bool =  false
    
    var body: some View {
        HStack {
            Text(dataManager.filterType.rawValue)
                .textStyle(RegularTextStyle())
            Spacer()
            
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 12)
        .frame(width: 150, height: 32)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .frame(width: 150)
                HStack{
                    Spacer()
                    Menu {
                        ForEach(Constants.dataFilterType.allCases, id: \.rawValue) { item in
                            Button(action: {
                                if forMap{
                                    mapManager.filterType = item
                                }else{
                                    dataManager.filterType = item
                                }
                            }) {
                                Text(item.rawValue)
                            }
                        }
                    } label: {
                        Rectangle()
                            .fill(Constants.Colour.PrimaryBlue)
                            .frame(width: 36, height: 32)
                    }
                }
            }
        )
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview{
    DataFilterDropdownMenu()
        .environmentObject(DataManager.shared)
}
