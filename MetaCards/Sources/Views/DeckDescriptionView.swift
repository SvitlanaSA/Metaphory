//
//  DeckDescriptionView.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 22.01.2024.
//

import SwiftUI
import SharedStuff
import StoreKit

struct DeckDescriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FolderViewModel

    var body: some View {
        VStack {
            headerView()
            presentatedImagesView()
            titleView()
            fullDecriptionView()
            Spacer()
        }
        .padding(.horizontal, 6)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 0))
        .ignoresSafeArea(edges: .bottom)
    }

    private func headerView() -> some View {
        HStack{
            Button(action: {
                self.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 12)

            })
            .frame(width: 70, height: 50)
            .foregroundStyle(Color.black.opacity(0.6))
            Spacer()

            if let product = viewModel.nonPurchasedProduct {
                buyDeck(product: product)
            }
        }
        .frame(height: 50)
    }

    @ViewBuilder private func buyDeck(product: Product) -> some View {
        Text("Unlock for ".localizedString)
            .font(.defaultApp(size: 17))
            .foregroundStyle(Color.foregroundColor)

        Button(action: {
            viewModel.purchaseProduct()
        }, label: {
            Text(product.displayPrice)
                .font(.defaultApp(size: 20))
                .foregroundStyle(.white)
        })

        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundColor)
                .padding(.all, -6)
        }
        .padding(.trailing, 15)
    }

    private func titleView() -> some View {
        Text(viewModel.title.localizedString)
            .font(.defaultApp(size: 30))
            .bold()
            .padding(.top, UIDevice.isIphone ? 15 : 20)
            .padding([.bottom, .leading, .trailing], 10)
            .foregroundColor(Color.foregroundColor)

    }

    private func fullDecriptionView() -> some View {
        ScrollView {
            Text(viewModel.fullDescription.localizedString)
                .font(.defaultApp(size: 19))
                .padding(.all, 10)
                .padding(.top, UIDevice.isIphone ? -14 : 0)
                .frame(alignment: .center)
        }
        .padding(.bottom, 20)
    }

    private func presentatedImagesView() -> some View {
        HStack(spacing: UIDevice.isIphone ? 28 : 35) {
            ForEach(viewModel.presentationImages, id: \.self) { name in
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.top, viewModel.imagesVerticalPadding[name]!)
                    .padding(.bottom, -viewModel.imagesVerticalPadding[name]!)
                    .rotationEffect(.degrees(viewModel.imageDegrees[name]!))

            }
        }.frame(height: UIDevice.isIphone ? 105 : 170)
            .padding(.vertical, 0)
            .padding(.horizontal, 20)
    }
}

#Preview {
    let format = "\(#keyPath(CDFolder.cdIndex)) == 1"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    let viewModel = FolderViewModel(folder: folder)
    return NavigationStack {
        DeckDescriptionView(viewModel: viewModel)
    }
}
