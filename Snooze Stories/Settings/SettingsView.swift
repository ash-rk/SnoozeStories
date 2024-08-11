//
//  SettingsView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 13/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var sharedState: SharedState
    var body: some View {
        NavigationView {
            LogoutView()
        }
    }
}

#Preview {
    SettingsView(sharedState: SharedState())
}
