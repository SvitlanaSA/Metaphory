//
//  TechniquesSheet.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 08.02.2024.
//

import SwiftUI

struct TechniquesSheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                TechniqueSettingView()
                    .padding(.top, 60)
                    .environmentObject(TechniqueSettingViewModel())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                Text("cWorkingwithCards")
                    .font(.defaultApp(size: 23))
                    .bold()
                    .foregroundStyle(Color.foregroundColor)
                    .padding(.top, 20)
                    .lineLimit(2)
            }
            .background(Color.settingColor)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    BackButton(dismiss: dismiss, "xmark")
                }
            }
        }
        .tint(Color.foregroundColor)


    }
}

#Preview {
    return TechniquesSheet()
}

