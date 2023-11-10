//
//  NointernetView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
            Text("You're out.")
        }
    }
}

#Preview {
    NoInternetView()
}

