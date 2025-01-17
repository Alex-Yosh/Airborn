//
//  Loading.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct Loading: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    // 2 second time for now
    @State var timeRemaining = 2
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("Loading")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }else{
                    navigationManager.appStatus.value = .restOfApp
                }
            }
    }
}

#Preview {
    Loading()
}
