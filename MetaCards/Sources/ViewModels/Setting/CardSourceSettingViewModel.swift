//
//  CardSourceSettingViewModel.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 20.02.2024.
//

import PDFKit
import SharedStuff
import Combine

class CardSourceSettingViewModel: ObservableObject {

    private var pdfURLString: String {
        let langStr = Locale.current.language.languageCode?.identifier
        if langStr == "uk" {
            return ""
        } else if langStr == "ru" {
            return ""
        } else {
            return ""
        }
    }
    @Published var pdfDocument: PDFDocument?
    @Published var error: Error?
    private var cancellable: Cancellable?

    func loadSourcePDFFile() {
        cancellable = FirebaseLoadDataHelper.fetchData(urlString: pdfURLString) {[weak self] result in
            switch result {
                case .success(let data):
                    self?.pdfDocument = PDFDocument(data: data)
                case .failure(let failure):
                    self?.error = failure
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
