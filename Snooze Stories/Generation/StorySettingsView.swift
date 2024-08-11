//
//  StorySettingsView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 20/05/2024.
//

import SwiftUI

struct StorySettingsView: View {
    @Binding var isShowingModal: Bool
    @Binding var selectedTimePeriod: String
    @Binding var selectedLocation: String

    var timePeriods = ["Medieval", "Victorian", "Modern", "Future"]
    var locations: [String] {
        switch selectedTimePeriod {
        case "Medieval":
            return ["Forest", "Castle", "Village"]
        case "Victorian":
            return ["City", "Townhouse", "Mansion"]
        case "Modern":
            return ["City", "Suburb", "Space Station"]
        case "Future":
            return ["Space Station", "Moon Base", "Mars Colony"]
        default:
            return []
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time Period")) {
                    Picker("Select a Time Period", selection: $selectedTimePeriod) {
                        ForEach(timePeriods, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedTimePeriod) {
                        selectedLocation = locations.first ?? ""
                    }
                }

                Picker("Select a Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.inline)
            }
            .navigationBarTitle("Choose Setting", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingModal = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        print("Time Period: \(selectedTimePeriod), Location: \(selectedLocation)")
                        isShowingModal = false
                    }
                }
            }
        }
    }
}


#Preview {
    StorySettingsView(isShowingModal: .constant(false), selectedTimePeriod: .constant("Medieval"), selectedLocation: .constant(""))
}
