//
//  TextualCardDetailView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 12.01.2024.
//

import SwiftUI
import SharedStuff

struct TextualCardDetailView: View {
    @EnvironmentObject private var viewModel: TextualCardDetailViewModel
    @Binding var isFullScreen: Bool

    init(fullScreen: Binding<Bool>) {
        _isFullScreen = fullScreen
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            viewModel.backgroundColor()
            VStack {
                ForEach(0..<3) { _ in
                    Spacer()
                }
                HStack {
                    Spacer(minLength: UIDevice.isIphone ? 30 : 100)
                    Text(viewModel.title.localizedString)
                        .lineLimit(nil)
                        .font(.affirmationFont(size: UIDevice.isIphone ? 24 : 26))
                        .foregroundColor(.black)
                        .frame(alignment: .center)
                    Spacer(minLength: UIDevice.isIphone ? 30 : 100)
                }
                ForEach(0..<4) { _ in
                    Spacer()
                }
            }
            HStack {
                Spacer()
                Image(viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.trailing, UIDevice.isIphone ? 5 : 30)
            }
        }
        .ignoresSafeArea()
        .onTapGesture{
            isFullScreen.toggle()
        }
    }
}

#Preview {
    let format = "\(#keyPath(CDCard.cdCardType)) == \"\(CardType.quates.rawValue)\""
    let card = PreviewAssistance.instance.fetchTestedCard(predicate: format)
    let viewModel = TextualCardDetailViewModel(card: card)
    return NavigationStack {
        TextualCardDetailView(fullScreen: .constant(false))
            .environmentObject(viewModel)
    }
}
