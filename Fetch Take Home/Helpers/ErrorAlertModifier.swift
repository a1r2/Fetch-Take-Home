//
//  ErrorAlertModifier.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/11/23.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?

    func body(content: Content) -> some View {
        content
            .alert(isPresented: Binding<Bool>(
                get: { self.errorMessage != nil },
                set: { _ in self.errorMessage = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}
