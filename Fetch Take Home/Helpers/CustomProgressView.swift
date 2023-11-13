//
//  CustomProgressView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/11/23.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

