//
//  FontStyle.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import Foundation
import SwiftUI

// Inter-Bold weight 700, Inter-SemiBold weight 500, Inter weight 400

    


//Loading
struct LoadingTextStyle: ViewModifier {
    
    static var fontSize = 45.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Dolce Vita", size: LoadingTextStyle.fontSize))
            .foregroundColor(LoadingTextStyle.color)
    }
}

//Main
struct HeadingTextStyle: ViewModifier {
    
    static var fontSize = 24.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: HeadingTextStyle.fontSize))
            .foregroundColor(HeadingTextStyle.color)
    }
}

struct SubHeadingTextStyle: ViewModifier {
    
    static var fontSize = 20.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: SubHeadingTextStyle.fontSize))
            .foregroundColor(SubHeadingTextStyle.color)
    }
}


struct RegularTextStyle: ViewModifier {
    
    static var fontSize = 16.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: RegularTextStyle.fontSize))
            .foregroundColor(RegularTextStyle.color)
    }
}

//Home
struct HomeScaleAQIbigTextStyle: ViewModifier {
    
    static var fontSize = 75.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: HomeScaleAQIbigTextStyle.fontSize))
            .foregroundColor(HomeScaleAQIbigTextStyle.color)
    }
}

struct HomeScaleAQIsmallTextStyle: ViewModifier {
    
    static var fontSize = 20.0
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: HomeScaleAQIsmallTextStyle.fontSize))
    }
}

struct LocationTextStyle: ViewModifier {
    
    static var fontSize = 18.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: LocationTextStyle.fontSize))
            .foregroundColor(LocationTextStyle.color)
    }
}

struct BarLowHighTextStyle: ViewModifier {
    
    static var fontSize = 15.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: LocationTextStyle.fontSize))
            .foregroundColor(LocationTextStyle.color)
    }
}



//Map
struct MapQuestionTextStyle: ViewModifier {
    
    static var fontSize = 12.0
    static var color: Color = Constants.Colour.DarkGray
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: MapQuestionTextStyle.fontSize))
            .foregroundColor(MapQuestionTextStyle.color)
    }
}

//Data
struct DataHeadingTextStyle: ViewModifier {
    
    static var fontSize = 16.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter-Bold", size: DataHeadingTextStyle.fontSize))
            .foregroundColor(DataHeadingTextStyle.color)
    }
}

struct DataSubHeadingTextStyle: ViewModifier {
    
    static var fontSize = 16.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter", size: DataHeadingTextStyle.fontSize))
            .foregroundColor(DataHeadingTextStyle.color)
    }
}






extension Text {
    func textStyle<Style:ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

