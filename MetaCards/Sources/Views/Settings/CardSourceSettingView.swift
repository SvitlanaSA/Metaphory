//
//  CardSourceSettingView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 20.02.2024.
//
import SharedStuff
import SwiftUI
import PDFKit


struct CardSourceSettingView: View {
    @EnvironmentObject var viewModel: CardSourceSettingViewModel


    var body: some View {

        VStack {
            if viewModel.error != nil {
                Text("Please check your internet connection")
                    .font(.defaultApp(size: 25))
                    .foregroundStyle(Color.foregroundColor)
                    .padding(.all, 20)
                    .padding(.top, 40)
            } else if let pdfDocument = viewModel.pdfDocument {
                PDFKitView(showing: pdfDocument, backgroundColor: UIColor(Color.settingColor))
            }
            else {
                ProgressView()
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.settingColor.scaledToFill())
            .ignoresSafeArea(edges: .bottom)
            .onAppear {
                viewModel.loadSourcePDFFile()
            }
    }
}

#Preview {
    CardSourceSettingView()
        .environmentObject(CardSourceSettingViewModel())
}
