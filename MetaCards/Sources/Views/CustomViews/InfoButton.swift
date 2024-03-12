//
//  InfoButton.swift
//  Metaphory
//
//  Created by Svetlana Stegnienko on 08.02.2024.
//

import SwiftUI

struct InfoButton: View {
    let action: () -> Void
    
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "info.circle")
        }
    }
}

#Preview("Clear state") {
    InfoButton { }
}

