//
//  DefineThemeView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 20/05/2024.
//

import SwiftUI

struct DefineThemeView: View {
    @Binding var isShowingModal: Bool
    @Binding var selectedTheme: String
    let predefinedThemes = ["Friendship", "Courage", "Kindness", "Adventure", "Love", "Justice", "Growth"]

    var body: some View {
        NavigationView {
            List {
                ForEach(predefinedThemes, id: \.self) { theme in
                    Button(action: {
                        selectedTheme = theme
                        // Optionally, dismiss the modal on selection
//                         isShowingModal = false
                    }) {
                        HStack {
                            Text(theme)
                                .foregroundColor(selectedTheme == theme ? .white : .primary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .padding()
                        .background(selectedTheme == theme ? Color.blue : Color.clear)
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Section(header: Text("Or define your own theme:")) {
                    TextField("Enter custom theme", text: $selectedTheme)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Define Theme", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingModal = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Process the selected or entered theme
//                        print("Theme selected: \(selectedTheme)")
                        isShowingModal = false
                    }
                }
            }
        }
    }
}


#Preview {
    DefineThemeView(isShowingModal: .constant(false), selectedTheme: .constant("Kindness"))
}
