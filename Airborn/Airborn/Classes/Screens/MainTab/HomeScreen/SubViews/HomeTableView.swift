//
//  HomeTableView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-20.
//

import SwiftUI

struct HomeTableView: View {
    var body: some View {
        VStack{
            Text("Recent Reading")
                .textStyle(SubHeadingTextStyle())
            RoundedRectangle(cornerRadius: 34)
                .fill(Constants.Colour.PrimaryGreen.opacity(0.4))
                .frame(height: 250).padding(.horizontal, 32)
        }
    }
}

#Preview {
    HomeTableView()
}
