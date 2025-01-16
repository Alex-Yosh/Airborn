//
//  DataView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct DataView: View {
    var body: some View {
        ZStack{
            Constants.Colour.SecondaryLightGray.ignoresSafeArea()
            ScrollView(){
                Grid() {
                    GridRow
                    {
                        DataTempView()
                    }
                    GridRow {
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    DataView()
}
