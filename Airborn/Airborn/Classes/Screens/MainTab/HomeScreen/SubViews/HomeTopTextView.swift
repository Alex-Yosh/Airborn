//
//  HomeTopTextView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeTopTextView: View {
    
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        VStack(spacing: 6){
            Text(Date.now, format: .dateTime.day().month(.wide).year())
                .textStyle(SubHeadingTextStyle())
            if let address = mapManager.sensorAddress{
                HStack{
                    Image("MapPin")
                    Text(address)
                            .textStyle(LocationTextStyle())
                }
            }

        }
    }
    
    func greeting() ->String{
        let date = NSDate()
        let calender = NSCalendar.current
        let hour = calender.component(.hour, from: date as Date)
        let hourInt = Int(hour.description)!
        
        switch(hourInt)
        {
        case 0...6:
            return "You should sleep"
        case 7...11:
            return "Good Morning"
        case 12...16:
            return "Good Afternoon"
        case 17...20:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}

#Preview {
    HomeTopTextView()
        .environmentObject(MapManager.shared)
        .environmentObject(DataManager.shared)
}
