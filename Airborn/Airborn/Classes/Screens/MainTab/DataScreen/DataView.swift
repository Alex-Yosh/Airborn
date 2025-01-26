//
//  DataView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct DataView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack{
            Constants.Colour.SecondaryLightGray.ignoresSafeArea()
            if dataManager.selectedDataType != nil{
                DataDetailView()
            }else{
                DataScrollView()
            }
        }
    }
}



struct DataBoxStyle: ViewModifier {
    
    var title: String
    
    static var fontSize = 16.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
            VStack{
                
                Text(title)
                    .textStyle(DataHeadingTextStyle()).padding()
                Spacer()
                content
                Spacer()
            }
        }.padding(.horizontal)
    }
}

extension View {
    func dataBoxStyle(title: String) -> some View {
        modifier(DataBoxStyle(title: title))
    }
}

#Preview {
    DataView()
        .environmentObject(DataManager.shared)
}
