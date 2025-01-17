//
//  DataView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct DataView: View {
    var body: some View {
        ZStack{
            Constants.Colour.SecondaryLightGray.ignoresSafeArea()
            ScrollView(){
                HStack{
                    Text("My Exposure")
                        .textStyle(HeadingTextStyle())
                    Spacer()
                }.padding()
                Grid() {
                    GridRow
                    {
                        DataTempView()
                            .dataBoxStyle(title: "Temperature")
                            .padding(.horizontal)
                        
                        DataHumidityView()
                            .dataBoxStyle(title: "Humidity")
                            .padding(.horizontal)
                    }
                    
                    GridRow {
                    }
                }
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
        }
    }
}

extension View {
    func dataBoxStyle(title: String) -> some View {
        modifier(DataBoxStyle(title: title))
    }
}

#Preview {
    DataView()
}
