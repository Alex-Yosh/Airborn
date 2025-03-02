//
//  DataBoxStyle.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-25.
//

import SwiftUI

struct DataBoxStyle: ViewModifier {
    
    var title: String
    var titleIn: Bool
    
    func body(content: Content) -> some View {
        ZStack{
            if (!titleIn){
                VStack{
                    HStack{
                        Text(title)
                            .textStyle(DataHeadingTextStyle())
                        Spacer()
                    }
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                        Spacer()
                        content.padding()
                        Spacer()
                    }
                }
            }else{
                
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
        }.padding(.horizontal)
    }
}

extension View {
    func dataBoxStyle(title: String, titleIn: Bool) -> some View {
        modifier(DataBoxStyle(title: title, titleIn: titleIn))
    }
}
