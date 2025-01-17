//
//  TabIcon.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct TabIcon: View {
    var imageString: String
    var textString: LocalizedStringKey
    var on: Bool = false    
    
    var body: some View {
        VStack {
            Image(systemName: imageString).padding()
            Text(textString)
        }
        .foregroundColor(on ? Constants.Colour.PrimaryBlue : .black)
    }
}

#Preview {
    TabIcon(imageString: "house", textString: "Home")
}
