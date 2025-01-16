//
//  FontStyle.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import Foundation
import SwiftUI

// Inter-Bold weight 700, Inter-SemiBold weight 500, Inter weight 400

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
struct HomeScaleTextStyle: ViewModifier {
    
    static var fontSize = 44.0
    static var color: Color = .black
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Inter-Bold", size: HomeScaleTextStyle.fontSize))
            .foregroundColor(HomeScaleTextStyle.color)
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






extension Text {
    func textStyle<Style:ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

