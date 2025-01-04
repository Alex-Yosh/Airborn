//
//  NavigationManager.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import Foundation
import Combine
import SwiftUI


class NavigationManager: ObservableObject {
    
    static var shared = NavigationManager()
    
    var appStatus: CurrentValueSubject<Constants.appNavigationControllers, Never> = .init(.loading)
    @Published var selectedHomeTab: Constants.mainTabType = .home
    
    
    
}
