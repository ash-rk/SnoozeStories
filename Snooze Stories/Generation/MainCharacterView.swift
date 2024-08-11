//
//  MainCharacterView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 20/05/2024.
//

import SwiftUI

struct MainCharacterView: View {
    @Binding var isShowingModal: Bool
    @Binding var name: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter protagonist's name", text: $name)
                        .textFieldStyle(.plain)
                }
            }
            .navigationBarTitle("Protagonist Details", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isShowingModal = false
                },
                trailing: Button("Done") {
                    print("Protagonist: \(name)")
                    isShowingModal = false
                }
            )
        }
    }
}

#Preview {
    MainCharacterView(isShowingModal: .constant(false), name: .constant(""))
}
