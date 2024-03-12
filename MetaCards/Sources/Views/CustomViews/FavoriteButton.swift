//
//  FavoriteButton.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 15.01.2024.
//

import SwiftUI

struct FavoriteButton: View {
    var filled: Bool = false
    let action: () -> Void

    private var imageName: String {
        filled ? "heart.fill" : "heart"
    }

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
                .bold()
        }
    }
}

#Preview("Clear state") {
    FavoriteButton { }
}

#Preview("Filled state") {
    FavoriteButton(filled: true) { }
}
