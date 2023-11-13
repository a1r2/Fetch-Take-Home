//
//  Fetch_Take_HomeApp.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

@main
struct Fetch_Take_HomeApp: App {
    var body: some Scene {
        WindowGroup {
            DessertListView(viewModel: MealsViewModel())
        }
    }
}
