//
//  FolderRowView.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 18.12.2023.
//

import SwiftUI
import SharedStuff

struct FolderRowView: View {
    @StateObject var viewModel: FolderViewModel
    var body: some View {
        VStack {
            titleView()
            descriptionView()
            if !viewModel.folder.cdFavorite {
                footerView()
            } else {
                Spacer().frame(height: 27)
            }

        }
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 30))
    }

    private func titleView() -> some View {
        return HStack(alignment: .center) {
            Spacer()
            Text(viewModel.title.localizedString)
                .frame(alignment: .center)
                .font(.defaultApp(size:22))
                .bold()
                .foregroundColor(Color(red: 40/255, green: 76/255, blue: 88/255))
                .multilineTextAlignment(.center).padding(.horizontal, 5)
            Spacer()
        }
        .padding(.top, 13)
        .padding(.bottom, -2)
    }

    private func descriptionView() -> some View {
        return HStack(alignment: .center) {
            Image(viewModel.imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(4)
                .frame(width: 42)
                .padding(.leading, 10)
            Text(viewModel.subtitle.localizedString)
                .frame(alignment: .leading)
                .font(.defaultApp(size:18))
                .foregroundColor(Color(red: 40/255, green: 76/255, blue: 88/255))
                .padding(.leading, 7)
                .multilineTextAlignment(.leading)
            Spacer()
        }.padding(.all, 2)
            .padding(.top, -2)
    }

    private func footerView() -> some View {
        return HStack  {

            Button(action: {
                self.viewModel.showingDescriptionSheet.toggle()
            }, label: {
                if viewModel.folder.locked {
                    Image(systemName: "lock")
                        .frame(width: 14, alignment: .trailing)
                        .padding([.trailing, .leading], 20)
                        .padding(.bottom, 6)
                        .foregroundStyle(Color.foregroundColor)
                        .padding(.top, 0)
                }
            })
            .frame(width: 80, height: 45)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    self.viewModel.showingDescriptionSheet.toggle()
                }, label: {
                    Image("infoGreen")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, alignment: .trailing)
                        .padding([.trailing, .leading], 20)
                        .padding(.bottom, 6)
                        .padding(.top, 0)
                })

            }.frame(width: 80, height: 45)
            .sheet(isPresented: $viewModel.showingDescriptionSheet) {
                DeckDescriptionView(viewModel: FolderViewModel(folder: self.viewModel.folder))
                    .presentationDetents([.fraction(0.95)])
                    .presentationBackground(.clear)
            }
        }.padding(.top, -8)
    }
}

#Preview {
    let format = "\(#keyPath(CDFolder.cdIndex)) == 1"
    let folder = PreviewAssistance.instance.fetchTestedFolder(predicate: format)
    let viewModel = FolderViewModel(folder: folder)
    return NavigationStack {
        FolderRowView(viewModel: viewModel)
    }
}
