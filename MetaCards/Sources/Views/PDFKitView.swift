//
//  PDFKitView.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 20.02.2024.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {

    let pdfDocument: PDFDocument
    let backgroundColor: UIColor

    init(showing document: PDFDocument, backgroundColor: UIColor) {
        self.pdfDocument = document
        self.backgroundColor = backgroundColor
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.backgroundColor = backgroundColor
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displaysPageBreaks = false
        pdfView.pageShadowsEnabled = false

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

