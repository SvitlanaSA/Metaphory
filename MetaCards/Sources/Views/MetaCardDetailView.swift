//
//  MetaCardDetailView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.12.2023.
//

import SwiftUI
import SharedStuff
import Foundation
import PDFKit

struct MetaCardDetailView: View {
    @EnvironmentObject private var viewModel: MetaCardDetailViewModel
    @State private var showHintText = false
    @State var isFullScreen: Bool = false

    var body: some View {
        mainView()
            .fullScreenCover(isPresented: $isFullScreen) {
                fullScreenCoverView()
            }.transaction({ transaction in
                transaction.disablesAnimations = true
            })
    }

    // MARK: - Private methods
    private func mainView() -> some View {
        ZStack(alignment: .center) {
            frontImageView()
            hintView()
        }
        .ignoresSafeArea()
    }

    @ViewBuilder private func frontImageView() -> some View {
        ZStack(alignment: .center) {
            Color.clear.ignoresSafeArea()
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .overlay {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .onTapGesture {
            self.isFullScreen.toggle()
        }
        .gesture(MagnifyGesture().onChanged { value in
            if isFullScreen == false {
                self.isFullScreen.toggle()
            }
        })
    }

    private func fullScreenCoverView() -> some View {
        ZStack(alignment: .center) {
            if let image = viewModel.image {
                PDFKitView(showing: viewModel.createPDFDocument(image: image), backgroundColor: UIColor.black)
                    .onTapGesture {
                        isFullScreen.toggle()
                    }
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func hintView() -> some View {
        if viewModel.hasAdditionalValue {
            VStack {
                Spacer()
                textView()
                Spacer()
                showHideHintButton()
            }
        }
    }

    private func textView() -> some View {
        Text(viewModel.title)
            .lineLimit(nil)
            .padding(.vertical, 15)
            .font(.defaultApp(size: 20))
            .foregroundStyle(Color.foregroundColor)
            .bold()
            .padding(.horizontal, 20)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, UIDevice.isIphone ? 20: 100)
            .opacity(showHintText ? 1 : 0)
            .allowsHitTesting(false)
    }
    
    private func showHideHintButton() -> some View {
        Button {
            withAnimation {
                showHintText.toggle()
            }
        } label: {
            Text(showHintText ? "Hide hint" : "Show hint")
                .font(.defaultApp(size: 21))
                .foregroundStyle(Color.foregroundColor)
                .padding(.all, UIDevice.isIphone ? 8 : 15)
        }
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 30))
        .padding(.bottom, 40)
    }
}

#Preview("Card with button") {
    let format = "\(#keyPath(CDCard.cdCardType)) == \"\(CardType.metaCards.rawValue)\""
    let card = PreviewAssistance.instance.fetchTestedCard(predicate: format)
    card.title = "Some text"
    let viewModel = MetaCardDetailViewModel(attachmentResourceHelper: StubAttachmentResourceHelper(), card: card)
    return NavigationStack {
        MetaCardDetailView()
            .environmentObject(viewModel)
    }
}

#Preview("Card without button") {
    let format = "\(#keyPath(CDCard.cdCardType)) == \"\(CardType.metaCards.rawValue)\""
    let card = PreviewAssistance.instance.fetchTestedCard(predicate: format)
    let viewModel = MetaCardDetailViewModel(attachmentResourceHelper: StubAttachmentResourceHelper(), card: card)
    return NavigationStack {
        MetaCardDetailView()
            .environmentObject(viewModel)
    }
}
