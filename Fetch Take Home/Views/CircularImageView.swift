//
//  CircularImageView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

struct CircularImageView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    CircularImageView(image: Image("DD"))
}
