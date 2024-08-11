//
//  MainView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 13/04/2024.
//

import SwiftUI

class SharedState: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct MainView: View {
    @StateObject private var sharedState = SharedState()
    var body: some View {
        TabView(selection: $sharedState.selectedTab) {
            CreationView(sharedState: sharedState)
            .tabItem {
                Label("Create", systemImage: "wand.and.stars.inverse")
            }
            .tag(1)
            HomeView(sharedState: sharedState)
            .tabItem {
                Label("Explore", systemImage: "book.pages")
            }
            .tag(0)
            SettingsView(sharedState: sharedState)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
    }
}

#Preview {
    MainView()
}
