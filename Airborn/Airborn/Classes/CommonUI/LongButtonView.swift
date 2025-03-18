//
//  LongButtonView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-03-18.
//

import SwiftUI

struct LongButtonView: View {
    var title: String
    var systemImage: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor.opacity(0.8))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LongButtonView(title: "login", systemImage: "arrow.clockwise", backgroundColor: Color.blue, action: {})
}
