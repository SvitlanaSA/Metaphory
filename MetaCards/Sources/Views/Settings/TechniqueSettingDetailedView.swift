//
//  TechniqueSettingDetailedView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 07.02.2024.
//

import SwiftUI


struct TechniqueSettingDetailedView: View {
    private var text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        ScrollView {
            VStack{
                Text(text.localizedString)
                    .padding(.all, 20)
                    .frame(alignment: .leading)
                
                    .font(.defaultApp(size: 18))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)

            }
            .multilineTextAlignment(.leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.all, 20)

            .foregroundStyle(Color.foregroundColor)
            Spacer()
        }
        .background(Color.settingColor)
    }

    private func listRow(value: MetaphoricalTechniques) -> some View {
        Text(value.rawValue.localizedString)
            .font(.defaultApp(size: 22))
    }
}

#Preview {
    return TechniqueSettingDetailedView(text:"cTechniqueAchievingGoalDetailed")
}
