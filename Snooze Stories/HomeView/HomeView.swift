//
//  HomeView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 10/04/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var sharedState: SharedState
    @Environment(\.colorScheme) var environmentColorScheme
    var customColorScheme: CustomColorScheme {
        environmentColorScheme == .dark ? .dark : .light
    }
    
    
    @State private var searchBox = ""
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass").font(.body)
                        TextField("Search for Stories", text: $searchBox)
                    }
                    .padding()
                    .background(customColorScheme.secondary) // Apply background before clipShape
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.bottom, 20)
                    ZStack {
                        Image("ft2").resizable()
                            .aspectRatio(contentMode: .fill) // or .fill
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.9)]), startPoint: .center, endPoint: .bottom)
                        VStack (alignment: .leading) {
                            Spacer()
                            HStack {
                                Text("The Magic of Storytelling")
                                    .font(.body)
                                    .foregroundStyle(Color.white)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Image(systemName: "play.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(customColorScheme.accent2)
                                }

                            }
                        }.padding()
                    }
                    .frame(height: 220)
                    .padding(.vertical, 20)
                    CatalogueView(name: "Trending Stories")
                    CatalogueView(name: "Funny Stories")
                    CatalogueView(name: "Funny Stories")
                    CatalogueView(name: "Funny Stories")
                }
            }
            .padding([.leading, .trailing], 10)
            .navigationTitle("SNOOZE")
        }
    }
}

#Preview {
    HomeView(sharedState: SharedState())
}
