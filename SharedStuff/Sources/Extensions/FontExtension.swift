//
//  FontExtension.swift
//  MetaCards
//
//  Created by Svetlana Stegnienko on 22.01.2024.
//

import SwiftUI

public extension Font {
    static func defaultApp(size: CGFloat = 22) -> Font {
        return .custom("Cochin", size: size)
    }

    static func affirmationFont(size: CGFloat = 22) -> Font {
        return .custom("STHeitiSC-Light", size: size)
    }
}
