//
//  SettingButton.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 02.08.2023.
//

import SwiftUI

struct SettingButton: View {
    let action: () -> Void
    
    private var imageName: String {
        "gearshape"
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
    SettingButton { }
}
