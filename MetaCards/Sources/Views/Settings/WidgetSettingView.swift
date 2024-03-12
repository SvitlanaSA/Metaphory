//
//  WidgetSettingView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 19.02.2024.
//

import SwiftUI
import AVKit

struct WidgetSettingView: View {

    let player = AVPlayer(url:  Bundle.main.url(forResource: "widget", withExtension: "mov")!)

    var body: some View {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            macInstructionView()
        } else {
            iosInstructionView()
        }
    }

    private func macInstructionView() -> some View {
        VStack {
            Text("To view your favorite affirmations, quotes, and explore metaphorical cards, you don't need to open the app every time - simply add the widget and adjust the content refresh frequency:")
                .font(.defaultApp(size: 22))
                .bold()
                .padding()
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.foregroundColor)
            Text("Right-click on the desktop. Choose the widget editing section. Find the Metaphory widgets:")
                .foregroundStyle(Color.foregroundColor)
                .font(.defaultApp(size: 20))

            Image("widgetMacOS")
                .resizable()
                .scaledToFit()
                .padding(.top)
            Spacer()

        }
        .background(Color.settingColor)
        .frame(maxWidth: .infinity)
    }

    private func iosInstructionView() -> some View {
        VStack {
            Text("To view your favorite affirmations, quotes, and explore metaphorical cards, you don't need to open the app every time - simply add the widget and adjust the content refresh frequency:")
                .font(.defaultApp(size: 19))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 0)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.foregroundColor)

            VideoPlayer(player: player)
                .onAppear() {
                    player.seek(to: .zero)
                    player.play()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding(.horizontal, 25)
                .padding(.bottom, 10)

            Spacer()
        }.frame(maxWidth: .infinity)
            .background(Color.settingColor)
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    WidgetSettingView()
}
