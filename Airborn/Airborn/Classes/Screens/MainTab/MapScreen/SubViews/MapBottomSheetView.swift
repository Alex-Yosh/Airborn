//
//  MapBottomView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2025-01-03.
//

import Foundation
import SwiftUI

struct MapBottomSheetView: View {
    
    @State private var currentHeight: CGFloat
    
    var publicationUri: String
    let parentHeight: CGFloat
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let middleHeight: CGFloat
    var geo: GeometryProxy
    
    init(parentHeight: CGFloat, publicationUri: String, geo: GeometryProxy) {
        self.publicationUri = publicationUri
        self.geo = geo
        self.parentHeight = parentHeight
        self._currentHeight = State(initialValue: UIScreen.main.bounds.height / 2)
        let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        self.maxHeight = parentHeight - Constants.searchBarHeight - topSafeAreaHeight
        self.minHeight = parentHeight * 0.15
        self.middleHeight =  UIScreen.main.bounds.height / 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    VStack(alignment: .leading) {
                        HStack{
                            Spacer()
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(Constants.Colour.bottomSheetIndicator)
                                .frame(width: 36, height: 5)
                            Spacer()
                        }
                        Text("Search results")
                            .textStyle(SearchResultsStyle())
                            .padding(.bottom, Constants.globalPadding)
                            .padding(.top, Constants.searchPadding)
                            .padding([.leading, .trailing])
                        if let publication = PublicationManager.shared.publications[publicationUri] {
                            PublicationSearchDetailView(uri: publication.metadata.uri, publicationId: publication.metadata.id, description: publication.metadata.description, status: publication.metadata.status)
                        }
                        Spacer()
                    }
                    .padding(.top, 6)
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .frame(height: currentHeight)
                    .offset(y: parentHeight - Constants.searchBarHeight - currentHeight)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let newHeight = currentHeight - value.translation.height
                                let heights = [minHeight, middleHeight, maxHeight]
                                let closest = heights.min(by: { abs($0 - newHeight) < abs($1 - newHeight) }) ?? middleHeight
                                currentHeight = closest
                            }
                    )
                    Spacer()
                }
                .animation(.interactiveSpring())
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
