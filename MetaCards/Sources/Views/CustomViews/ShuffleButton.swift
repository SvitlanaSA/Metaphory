//
//  ShuffleButton.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 28.11.2023.
//

import SwiftUI

struct ShuffleButton: View {
    let action: () -> Void
    
    private var imageName: String {
        "shuffle"
    }

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: imageName)
        }
    }
}

#Preview {
    ShuffleButton{ }
}
