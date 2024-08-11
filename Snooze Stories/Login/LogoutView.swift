//
//  LogoutView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 13/04/2024.
//

import SwiftUI
import Firebase

struct LogoutView: View {
    @AppStorage("auth_status") private var isAuthenticated: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                Button("Logout?") {
                    try? Auth.auth().signOut()
                    isAuthenticated = false
                }
            }
            .navigationTitle("Logout View")
        }
    }
}

#Preview {
    LogoutView()
}
