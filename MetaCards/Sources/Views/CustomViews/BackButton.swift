//
//  BackButton.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 02.08.2023.
//

import SwiftUI

struct BackButton: View {
    let dismiss: DismissAction?
    private let imageName: String

    init(dismiss: DismissAction?, _ imageName: String = "chevron.backward") {
        self.dismiss = dismiss
        self.imageName = imageName
    }

    var body: some View {
        Button {
            dismiss?()
        } label: {
            Image(systemName: imageName)
        }
    }
}

#Preview {
    BackButton(dismiss: nil)
}
