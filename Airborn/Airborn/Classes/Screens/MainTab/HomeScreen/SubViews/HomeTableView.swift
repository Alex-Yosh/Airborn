//
//  HomeTableView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeTableView: View {
    
    //TODO: add to some manager that recieves from database
    let exRecent = [RecentReading(date: Date.now, quality: "Okay"),         RecentReading(date: Date.now, quality: "Excellent"), RecentReading(date: Date.now, quality: "Good")]
    
    
    var body: some View {
        VStack{
            Text("Recent Reading")
                .textStyle(SubHeadingTextStyle())
            ZStack{
                RoundedRectangle(cornerRadius: 34)
                    .fill(Constants.Colour.PrimaryGreen.opacity(0.4))
                VStack{
                    Grid {
                        GridRow {
                            Text("Date")
                            Text("Quality")
                        }.padding(.vertical, 8)
                        
                        Divider()
                        
                        ForEach(Array(exRecent.enumerated()), id: \.offset){ index, recentReading in
                            
                            GridRow {
                                Text(recentReading.date, format: .dateTime.day().month().year()).frame(alignment: .leading)
                                Text(recentReading.quality)
                            }.padding(.vertical, 8)
                            Divider()
                        }
                    }
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Text("See More")
                                .textStyle(RegularTextStyle())
                        }).padding(.vertical, 8)
                        .padding(.horizontal)
                    }
                }
            }
            .frame(height: 250).padding(.horizontal, 32)
        }
    }
}

#Preview {
    HomeTableView()
}
