//
//  FilterButton.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 30.12.2023.
//

import SwiftUI

struct FilterButton: View {
    var filled: Bool = false
    let action: () -> Void

    private var imageName: String {
        filled ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
    }

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
        }
    }
}

#Preview("Clear state") {
    FilterButton { }
}

#Preview("Filled state") {
    FilterButton(filled: true) { }
}
