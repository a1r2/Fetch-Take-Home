//
//  PositionInCircleOverlay.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/11/23.
//

import SwiftUI

struct PositionInCircleOverlay: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .position(x: geometry.size.width - geometry.safeAreaInsets.trailing - 25,
                          y: geometry.size.height - geometry.safeAreaInsets.bottom)
        }
    }
}
