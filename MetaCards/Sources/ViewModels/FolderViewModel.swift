//
//  FolderViewModel.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 20.12.2023.
//
import SharedStuff
import Foundation
import StoreKit

class FolderViewModel: ObservableObject {
    @Published private (set) var folder: CDFolder
    @Published var showingDescriptionSheet = false

    init(folder: CDFolder) {
        self.folder = folder
    }

    var title: String {
        folder.title
    }

    var subtitle: String {
        folder.subtitle
    }

    var fullDescription: String {
        folder.fullDescription
    }

    var merchantID: String? {
        folder.merchantID
        //"\(folder.price == 0 ? 10.00 : folder.price)0 $"
    }

    var nonPurchasedProduct: Product? {
        return Store.instance.getUnpurchachedProduct(for: folder.merchantID)
    }

    var subtitleVisible: Bool {
        !subtitle.isEmpty
    }

    var imageName: String {
        "shirts/\(folder.title)/0"
    }

    var presentationImages: [String] {
        var result: [String] = []
        if !showImagePresentedSet {
            for i in 1...4 {
                result.append("shirts/\(folder.title)/\(i)")
            }
        }
        else {
            result.append("shirts/\(folder.title)/\(1)")
        }
        return result
    }

    var imageDegrees: [String: Double] {
        var result: [String: Double] = [:]
        let radians = showImagePresentedSet ? [0] : [-16.0, -7.0, 7.0, 16.0]
        for (index, name) in self.presentationImages.enumerated() {
            result[name] = radians[index]
        }
        return result
    }

    var imagesVerticalPadding: [String: CGFloat] {
        var result: [String: CGFloat] = [:]
        let padding = [14, 0.0, 0.0, 14.0]
        for (index, name) in self.presentationImages.enumerated() {
            result[name] = padding[index]
        }
        return result
    }

    func purchaseProduct() {
        guard let nonPurchasedProduct else {return}
        Task {
          try await Store.instance.purchase(nonPurchasedProduct)
        }
    }

    private var showImagePresentedSet: Bool {
        return folder.folderName == .affirmations || folder.folderName == .quote
    }
}
