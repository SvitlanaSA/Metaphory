//
//  LanguageView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 13.02.2024.
//

import SwiftUI

struct LanguageView: View {
    var body: some View {
        VStack {
            Text("""
                 Application support three languages:
                 * english
                 * ukrainian
                 * russian

                 You can choose another language in application settings:
                 """)
            .padding(.all, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.top, 40)
            .padding(.horizontal, 20)
            .font(.defaultApp(size: 22))

            Button("Open Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 1)
                        .padding(.all, -10)
                )
            .padding(.top, 30)
            .font(.defaultApp(size: 25))
            .buttonStyle(.plain)
            .foregroundColor(Color.foregroundColor)
            Spacer()
        }.frame(maxWidth: .infinity)
        .background(Color.settingColor)
    }
}

#Preview {
    LanguageView()
}
