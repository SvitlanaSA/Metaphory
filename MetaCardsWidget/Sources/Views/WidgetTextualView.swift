//
//  WidgetTextualView.swift
//  MetaCardsWidgetExtension
//
//  Created by Dmytro Maniakhin on 11.01.2024.
//

import WidgetKit
import SwiftUI
import SharedStuff

struct WidgetTextualView: View {
    @State var viewModel: WidgetTextualViewModelProtocol
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        if widgetFamily == .systemSmall {
            smallWidgetView()
        } else {
            largeMiddleWidgetView()
        }
    }

    private func smallWidgetView() -> some View {
        VStack(alignment: .trailing) {
            text(title: viewModel.title.localizedString)
                .padding(.vertical, 3)
                .padding(.horizontal, 6)
                .multilineTextAlignment(.center)
                .padding(.bottom, 36)

        }.containerBackground(for: .widget) {
            VStack (alignment: .leading) {
                Spacer()
                HStack{
                    Image("main")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)

                        .padding(.bottom, -1)
                        .padding(.leading, 6)
                    Spacer()
                    refreshButton()
                }.frame(height: 45)
            }
        }
    }

    private func largeMiddleWidgetView() -> some View {
        HStack {
            Spacer()
            text(title: viewModel.title.localizedString)
                .padding(.all, 8)
                .padding(.bottom, 2)
                .padding(.leading, 10)
                .padding(.trailing, -4)
                .font(.defaultApp(size: widgetFamily == .systemLarge ? 26 : 23))

            Spacer()
            VStack {
                refreshButton()
                    .padding([.trailing, .top, .leading], 6)

                Spacer()
                Image("main")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, -4)
            }
            .padding(.trailing, 5)
            .frame(width: widgetFamily == .systemLarge ? 45 : 40)

        }.containerBackground(for: .widget) {}
    }


    private func text(title: String) -> some View {
        Text(title)
            .font(.defaultApp(size: 23))
            .minimumScaleFactor(0.4)
            .multilineTextAlignment(.center)
            .bold()
            .foregroundColor(Color("tintColor"))
    }

    private func refreshButton() -> some View {
        Button(intent: RefreshDataAppIntent()) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: widgetFamily == .systemLarge ? 26 : 22))
                .foregroundStyle(Color("AirForceBlueColor"))
        }
        .tint(.white)
    }
}

#Preview(as: .systemExtraLarge, widget: {
    MetaCardsWidget()
}, timeline: {
    PersistenceControllerProvider.previewMode = true
    let intent = MetaCardsCategoriesIntent()
    intent.Category = IntentHandler.selection(for: .quates)
    let entry = WidgetEntryFactory.getRandomEntry(for: intent)
    return [entry]
})
