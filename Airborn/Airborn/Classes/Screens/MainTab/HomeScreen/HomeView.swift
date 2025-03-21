//
//  HomeView.swift
//  Airborn
//
//  Created by Alex Yoshida on 2024-12-19.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showSettingsSheet = false
    @State private var isRefreshing = false
    @State private var hasTriggeredRefresh = false
    @State private var dragOffset: CGFloat = 0

    let refreshThreshold: CGFloat = 80

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(colors: [Constants.Colour.PrimaryBlue, .white],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {

                    // ⬇️ Invisible geometry spacer to track pull offset
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                dragOffset = geo.frame(in: .global).minY
                            }
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                dragOffset = newValue
                                if dragOffset > refreshThreshold &&
                                    !isRefreshing &&
                                    !hasTriggeredRefresh {

                                    hasTriggeredRefresh = true
                                    isRefreshing = true
                                    Task {
                                        await refreshData()
                                        withAnimation {
                                            isRefreshing = false
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            hasTriggeredRefresh = false
                                        }
                                    }
                                }
                            }
                    }
                    .frame(height: 0)

                    if isRefreshing {
                        AirborneSpinner()
                            .padding(.top, 4)
                    }

                    ZStack {
                        HomeTopTextView()
                        HStack {
                            Spacer()
                            HomeSettingButtonView(showSettingsSheet: $showSettingsSheet)
                        }
                    }

                    if let latestData = dataManager.latestSensorData {
                        TemperatureHumidityView(
                            temperature: latestData.temperature,
                            humidity: latestData.humidity
                        )
                        .homeBoxStyle()

                        GeometryReader { geometry in
                            HomeScaleView()
                                .frame(width: geometry.size.width)
                                .frame(height: geometry.size.width * 0.8)
                        }
                        .frame(height: UIScreen.main.bounds.width * 0.8)

                        VStack(spacing: 12) {
                            HomeBarView(title: "TVOC", value: latestData.tvoc, unit: "", progress: latestData.getQualityPercentage(ofType: .tvoc))
                                .homeBoxStyle()

                            HomeBarView(title: "PM2.5", value: latestData.pm25, unit: Constants.dataTypes.pm25.metric, progress: latestData.getQualityPercentage(ofType: .pm25))
                                .homeBoxStyle()

                            HomeBarView(title: "CO2", value: latestData.co2, unit: Constants.dataTypes.co2.metric, progress: latestData.getQualityPercentage(ofType: .co2))
                                .homeBoxStyle()
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showSettingsSheet) {
            HomeSettingBottomSheetView()
                .presentationDetents([.fraction(0.3)])
        }
    }

    func refreshData() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
    }
}


// Track scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct AirborneSpinner: View {
    @State private var text: String = "A"
    @State private var opacity: Double = 1.0

    var body: some View {
        Text(text)
            .textStyle(LoadingTextStyle())
            .opacity(opacity)
            .onAppear {
                animateText()
                animateOpacity()
            }
    }

    func animateText() {
        let fullText = "AIRBORNE"
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(index)) {
                text = String(fullText.prefix(index + 1))
            }
        }
    }

    func animateOpacity() {
        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            opacity = 0.2
        }
    }
}



#Preview {
    HomeView()
        .environmentObject(DataManager.shared)
        .environmentObject(MapManager.shared)
        .environmentObject(LoginManager.shared)
}
