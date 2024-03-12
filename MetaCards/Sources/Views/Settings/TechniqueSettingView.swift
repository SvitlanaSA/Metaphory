//
//  TechniqueSettingView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 07.02.2024.
//

import SwiftUI

struct TechniqueSettingView: View {
    @EnvironmentObject var viewModel: TechniqueSettingViewModel

    var body: some View {
        List(viewModel.techniques, selection: $viewModel.selectedID)
        { value in
            NavigationLink {
                TechniqueSettingDetailedView(text: value.detailedTitle())
            } label: {
                listRow(value: value)
                .id(value.id)
            }
        }
        .foregroundStyle(Color.foregroundColor)
        .ignoresSafeArea(edges: .bottom)
        .scrollContentBackground(.hidden)
        .background(Color.settingColor)

    }

    private func listRow(value: MetaphoricalTechniques) -> some View {
        Text(value.rawValue.localizedString)
            .font(.defaultApp(size: 22))
    }
}

#Preview {
    let viewModel = TechniqueSettingViewModel()
    return TechniqueSettingView()
        .environmentObject(viewModel)
}
