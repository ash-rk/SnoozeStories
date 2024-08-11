//
//  ContentView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 08/04/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("auth_status") private var isAuthenticated: Bool = true
    var body: some View {
//        Skip LoginView when developing or testing code
        VStack {
            if isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
