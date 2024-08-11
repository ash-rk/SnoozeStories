//
//  GenerateView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 10/04/2024.
//

import SwiftUI

enum StorySetting {
    case defineTheme
    case chooseSetting
    case emotionalMood
    case mainCharacters
    case targetAudience
    case none
}

class StoryCreationViewModel: ObservableObject {
    @Published var selectedTheme: String = ""
    @Published var selectedTimePeriod: String = ""
    @Published var selectedLocation: String = ""
    @Published var selectedMood: String = ""
    @Published var protagonistName: String = ""
    @Published var audienceAgeYears: Int = 0
    @Published var audienceAgeMonths: Int = 0
    
    var isFormValid: Bool {
        !selectedTheme.isEmpty &&
        !selectedTimePeriod.isEmpty &&
        !selectedLocation.isEmpty &&
        !selectedMood.isEmpty &&
        !protagonistName.isEmpty &&
        (audienceAgeYears > 0 || audienceAgeMonths > 0)
    }
    
    var combinedSetting: String {
        [selectedTimePeriod, selectedLocation].filter { !$0.isEmpty }.joined(separator: ", ")
    }
    
    var combinedAudienceAge: String {
        var parts: [String] = []
        if audienceAgeYears > 0 {
            parts.append("\(audienceAgeYears) year\(audienceAgeYears > 1 ? "s" : "")")
        }
        if audienceAgeMonths > 0 {
            parts.append("\(audienceAgeMonths) month\(audienceAgeMonths > 1 ? "s" : "")")
        }
        return parts.joined(separator: " and ")
    }
    
    func storyPrompt() -> String {
        return """
        Create a bedtime story with the following details:
        Theme: \(selectedTheme)
        Setting: \(combinedSetting)
        Mood: \(selectedMood)
        Main Character: \(protagonistName), who is \(combinedAudienceAge) old.
        Audience: Children aged \(combinedAudienceAge).
        Please make the story \(selectedMood.lowercased()), engaging, and suitable for children.
        """
    }
}

struct CreationView: View {
    @ObservedObject var sharedState: SharedState
    @Environment(\.colorScheme) var colorScheme
    var customColorScheme: CustomColorScheme {
        colorScheme == .dark ? .dark : .light
    }
    
    @State private var isShowingModal: Bool = false
    @State private var selectedSetting: StorySetting = .none
    @State private var storyPrompt: String = ""
    
    @StateObject var storyModel = StoryCreationViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                StorySetupView(
                    title: "Define Theme",
                    subtitle: "Central message or moral",
                    symbolName: "paintpalette.fill", 
                    setting: .defineTheme,
                    currentSelection: storyModel.selectedTheme.isEmpty ? nil : storyModel.selectedTheme,
                    isShowingModal: $isShowingModal,
                    selectedSetting: $selectedSetting
                )
                StorySetupView(
                    title: "Choose Setting",
                    subtitle: "Story location",
                    symbolName: "globe.europe.africa.fill",
                    setting: .chooseSetting,
                    currentSelection: storyModel.combinedSetting.isEmpty ? nil : storyModel.combinedSetting,
                    isShowingModal: $isShowingModal,
                    selectedSetting: $selectedSetting
                )
                StorySetupView(
                    title: "Emotional Mood",
                    subtitle: "Set the emotional tone",
                    symbolName: "tree.fill",
                    setting: .emotionalMood,
                    currentSelection: storyModel.selectedMood.isEmpty ? nil : storyModel.selectedMood,
                    isShowingModal: $isShowingModal,
                    selectedSetting: $selectedSetting
                )
                StorySetupView(
                    title: "Main Characters",
                    subtitle: "Who are the protagonists?",
                    symbolName: "person.fill.badge.plus",
                    setting: .mainCharacters,
                    currentSelection: storyModel.protagonistName.isEmpty ? nil : storyModel.protagonistName,
                    isShowingModal: $isShowingModal,
                    selectedSetting: $selectedSetting
                )
                StorySetupView(
                    title: "Target Audience",
                    subtitle: "Who is the audience?",
                    symbolName: "figure.wave",
                    setting: .targetAudience,
                    currentSelection: storyModel.combinedAudienceAge.isEmpty ? nil : storyModel.combinedAudienceAge,
                    isShowingModal: $isShowingModal,
                    selectedSetting: $selectedSetting
                )

                // Add more NavigationItemViews as needed
                .sheet(isPresented: $isShowingModal, content: {
                    VStack {
                        switch selectedSetting {
                        case .defineTheme:
                            DefineThemeView(isShowingModal: $isShowingModal, selectedTheme: $storyModel.selectedTheme)
                        case .chooseSetting:
                            StorySettingsView(isShowingModal: $isShowingModal, selectedTimePeriod: $storyModel.selectedTimePeriod, selectedLocation: $storyModel.selectedLocation)
                        case .emotionalMood:
                            EmotionalMoodView(isShowingModal: $isShowingModal, selectedMood: $storyModel.selectedMood)
                        case .mainCharacters:
                            MainCharacterView(isShowingModal: $isShowingModal, name: $storyModel.protagonistName)
                        case .targetAudience:
                            TargetAudienceView(isShowingModal: $isShowingModal, ageYears: $storyModel.audienceAgeYears, ageMonths: $storyModel.audienceAgeMonths)
                        case .none:
                            EmptyView() // Handle the 'none' case by not presenting any content
                        }
                    }
                    .presentationDetents([.medium, .large])
                        .interactiveDismissDisabled()
                })
                if storyModel.isFormValid {
                    let _ = print(storyModel.storyPrompt())
                }
                GenerateButtonView(isFormValid: storyModel.isFormValid, storyPrompt: storyModel.storyPrompt())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Welcome,")
                            .foregroundColor(customColorScheme.accent2)
                            .fontWeight(.heavy)
                        Text("Let's create a magical story!")
                            .foregroundColor(customColorScheme.primary)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .onChange(of: selectedSetting) {
            if selectedSetting != .none {
                isShowingModal = true
            }
        }
    }
}


#Preview {
    CreationView(sharedState: SharedState())
}

struct StorySetupView: View {
    var title: String
    var subtitle: String
    var symbolName: String
    var setting: StorySetting
    var currentSelection: String?
    
    @Environment(\.colorScheme) var colorScheme
    var customColorScheme: CustomColorScheme {
        colorScheme == .dark ? .dark : .light
    }
    
    @Binding var isShowingModal: Bool
    @Binding var selectedSetting: StorySetting

    var body: some View {
        VStack {
            Button(action: {
                selectedSetting = setting
                isShowingModal = true
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                        Text(currentSelection ?? subtitle)  // Use current selection if available
                            .font(.callout)
                            .foregroundColor(currentSelection != nil ? .green : customColorScheme.subText)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    Image(systemName: symbolName)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding(.trailing, 5)
                    VStack {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)  // Adapts to your color scheme
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(customColorScheme.secondary)
                .cornerRadius(13)
            }
            .buttonStyle(DefaultButtonStyle())
        }
        .padding(.top, 20)
        .padding(.horizontal)
    }
}
