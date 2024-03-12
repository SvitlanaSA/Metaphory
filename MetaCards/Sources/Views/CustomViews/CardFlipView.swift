//
//  CardFlipView.swift
//  MetaCards
//
//  Created by Dmytro Maniakhin on 26.12.2023.
//

import SwiftUI

struct CardFlipView<FrontView, BackwardView>: View where FrontView : View, BackwardView : View {
    @Binding private var isFlipped: Bool
    private let rightToLeftFlip: Bool
    private let backwardView: () -> BackwardView
    private let frontView: () -> FrontView
    
    init(flipped: Binding<Bool>,
         rightToLeftFlip: Bool = true,
         @ViewBuilder frontView: @escaping () -> FrontView,
         @ViewBuilder backwardView: @escaping () -> BackwardView) {
        _isFlipped = flipped
        self.rightToLeftFlip = rightToLeftFlip
        self.frontView = frontView
        self.backwardView = backwardView
    }
    
    var body: some View {
        ZStack {
            frontView()
                .modifier(FlipOpacity(opacityValue: isFlipped ? 0 : 1))
                .rotation3DEffect(rotationAngleOfFrontView(), axis: (x: 0, y: 1, z: 0))
            backwardView()
                .modifier(FlipOpacity(opacityValue: isFlipped ? 1 : 0))
                .rotation3DEffect(rotationAngleOfBackwardView(), axis: (x: 0, y: 1, z: 0))
        }
    }
    
    // MARK: - Private methods
    
    private func performFlip() {
        withAnimation {
            isFlipped.toggle()
        }
    }
    
    private func rotationAngleOfFrontView() -> Angle {
        .degrees(isFlipped ? -180 * signOfRotationAngle() : 0)
    }
    
    private func rotationAngleOfBackwardView() -> Angle {
        .degrees(!isFlipped ? 180 * signOfRotationAngle() : 0)
    }
    
    private func signOfRotationAngle() -> Double {
        rightToLeftFlip ? 1 : -1
    }
}

fileprivate struct FlipOpacity: AnimatableModifier {
   var opacityValue: Double = 0
   
   var animatableData: Double {
      get { opacityValue }
      set { opacityValue = newValue }
   }
   
   func body(content: Content) -> some View {
      content
           .opacity(opacityValue.rounded())
   }
}

#Preview {
    struct WrapperView: View {
        @State private var isFlipped = false
        
        var body: some View {
            CardFlipView(flipped: $isFlipped) {
                let title = "Front Content"
                Text(title)
            } backwardView: {
                let title = "Backward Content"
                Text(title)
            }
            .onTapGesture {
                withAnimation {
                    isFlipped.toggle()
                }
            }
        }
    }

    return WrapperView()
}
