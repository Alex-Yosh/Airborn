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
        static var PrimaryBlue = Color(red: 167/255, green: 211/255, blue: 224/255) //#A7D3E0
        static var PrimaryGreen = Color(red: 168/255, green: 216/255, blue: 185/255) //#A8D8B9
        static var SecondaryWhite = Color(red: 255/255, green: 255/255, blue: 255/255) //#FFFFFF
        static var SecondaryLightGray = Color(red: 245/255, green: 245/255, blue: 245/255) //#F5F5F5
        static var AccentYellow = Color(red: 255/255, green: 235/255, blue: 59/255) //#FFEB3B
        static var AccentOrange = Color(red: 255/255, green: 152/255, blue: 0/255) //#FF9800
    }
    
}
