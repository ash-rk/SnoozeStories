//
//  TargetAudienceView.swift
//  Snooze Stories
//
//  Created by Ashwin Ravikumar on 20/05/2024.
//

import SwiftUI

struct TargetAudienceView: View {
    @Binding var isShowingModal: Bool
    @Binding var ageYears: Int
    @Binding var ageMonths: Int

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Specify the Child's Age")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Years")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Stepper("\(ageYears)", value: $ageYears, in: 0...12)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Months")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Stepper("\(ageMonths)", value: $ageMonths, in: 0...11)
                        }
                    }

                    Text("The child is \(ageYears) years and \(ageMonths) months old.")
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                }
            }
            .navigationBarTitle("Target Audience", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    isShowingModal = false
                },
                trailing: Button("Done") {
                    print("Selected Age: \(ageYears) years and \(ageMonths) months")
                    isShowingModal = false
                }
            )
        }
        .accentColor(.blue)
    }
}

#Preview {
    TargetAudienceView(isShowingModal: .constant(false), ageYears: .constant(2), ageMonths: .constant(1))
}
