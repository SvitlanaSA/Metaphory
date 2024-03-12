//
//  NavigationButtonsView.swift
//  Metaphory
//
//  Created by Dmytro Maniakhin on 02.02.2024.
//

import SwiftUI

struct NavigationButtonsView: View {
    @State private var navigationButtonsVisible: Bool = false
    private var previousButtonDisabled: Bool
    private var nextButtonDisabled: Bool
    
    init(previousButtonDisabled: Bool, nextButtonDisabled: Bool) {
        self.previousButtonDisabled = previousButtonDisabled
        self.nextButtonDisabled = nextButtonDisabled
    }

    var body: some View {
        HStack {
            if navigationButtonsVisible {
                previousButtonView()
                Spacer()
                nextButtonView()
            }
        }
        .onAppear() {
            navigationButtonsVisible = true
            withAnimation(.default.delay(1.5)) {
                navigationButtonsVisible = false
            }
        }
    }
    
    // MARK: - Private methods

    private func previousButtonView() -> some View {
        Image(systemName: "chevron.compact.left")
            .font(.defaultApp(size: 50))
            .foregroundColor(Color.accentColor)
            .disabled(previousButtonDisabled)
    }
    
    private func nextButtonView() -> some View {
        Image(systemName: "chevron.compact.right")
            .font(.defaultApp(size: 50))
            .foregroundColor(Color.accentColor)
            .disabled(nextButtonDisabled)
    }
}

#Preview {
    NavigationButtonsView(previousButtonDisabled: false, nextButtonDisabled: false)
}
