//
//  Constants.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import Foundation
import SwiftUI

struct Constants {
    enum appNavigationControllers {
        case loading
        case restOfApp
    }
    
    enum mainTabType {
        case home
        case data
        case map
    }
    
    struct Colour {
        static var PrimaryBlue = Color(hex: "A7D3E0")
        static var PrimaryGreen = Color(hex: "A8D8B9")
        static var SecondaryWhite = Color(hex: "FFFFFF")
        static var SecondaryLightGray = Color(hex: "F5F5F5")
        static var AccentYellow = Color(hex: "FFEB3B")
        static var AccentOrange = Color(hex: "FF9800")
        
        static var ScaleRed = Color(hex: "ED4D4D")
        static var ScaleDarkOrange = Color(hex: "E59148")
        static var ScaleLightOrange = Color(hex: "EFBF39")
        static var ScaleYellow = Color(hex: "EEED56")
        static var ScaleGreen = Color(hex: "32E1A0")
    }
    
}
