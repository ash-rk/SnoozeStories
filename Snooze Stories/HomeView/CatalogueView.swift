//
//  CatalogueView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 10/04/2024.
//

import SwiftUI

struct CatalogueView: View {
    var name: String
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow, .gray, .black, .white]

    @State private var showingOverview = false
    @State private var selectedBookIndex: Int? = nil

    var body: some View {
        VStack (alignment: .leading) {
            Text(name)
            ScrollView (.horizontal) {
                HStack {
                    ForEach(0..<10) { index in
                        VStack {
                            Rectangle()
                                .frame(width: 100, height: 140)
                                .foregroundColor(colors[index % colors.count])
                                .padding(.leading, 10)
                                .onTapGesture {
                                    selectedBookIndex = index
//                                    showingOverview = true
                                }
                            Text("Name of the book: A Very Long Title That Might Wrap")
                                .lineLimit(3)
                                .font(.caption)
                                .frame(width: 130)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingOverview) {
            if let index = selectedBookIndex {
                BookOverviewView(bookIndex: index)
                    .presentationDetents([.medium, .large])
            } else {
                EmptyView()
            }
        }
    }
}

struct BookOverviewView: View {
    let bookIndex: Int

    var body: some View {
        VStack {
            Text("Overview for Book \(bookIndex)")
                .font(.headline)
                .padding()

            Text("Story Overview: [Insert overview for the specific book here]")
                .padding()

            Text("Moral: [Insert the moral of the story here]")
                .padding()

            Spacer()
        }
    }
}


#Preview {
    CatalogueView(name: "Funny Stories")
}
