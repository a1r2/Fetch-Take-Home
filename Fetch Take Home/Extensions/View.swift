//
//  View.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/11/23.
//

import SwiftUI

extension View {
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        self.modifier(ErrorAlertModifier(errorMessage: errorMessage))
    }
    
    func positionInCircleOverlay() -> some View {
        self.modifier(PositionInCircleOverlay())
    }
}
