//
//  HomeBoxStyle.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-10.
//

import SwiftUI

struct HomeBoxStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Constants.Colour.GrayishWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(0.8)
            .padding(.horizontal)
    }
}

extension View {
    func homeBoxStyle() -> some View {
        modifier(HomeBoxStyle())
    }
}
