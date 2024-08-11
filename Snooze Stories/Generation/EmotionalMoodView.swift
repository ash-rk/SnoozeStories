//
//  EmotionalMoodView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 20/05/2024.
//

import SwiftUI

struct EmotionalMoodView: View {
    @Binding var isShowingModal: Bool
    @Binding var selectedMood: String

    let moods = ["Joyful", "Sad", "Suspenseful", "Calm", "Scary", "Exciting"]

    var body: some View {
        NavigationView {
            List {
                Picker("Select the Emotional Mood", selection: $selectedMood) {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
                    }
                }
                .pickerStyle(.inline)
            }
            .navigationBarTitle("Emotional Mood", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isShowingModal = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        print("Selected Emotional Mood: \(selectedMood)")
                        isShowingModal = false
                    }
                }
            }
        }
    }
}


#Preview {
    EmotionalMoodView(isShowingModal: .constant(false), selectedMood: .constant("Joyful"))
}
