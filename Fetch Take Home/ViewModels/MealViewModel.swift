//
//  MealViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false

    func fetch(category: String) {
        print(FetchApi.meals(category: category).components)
        Task {
            do {
                let mealsData = try await Services.categories(category: category)
                DispatchQueue.main.async {
                    self.isLoading = true
                    self.meals = mealsData.meals
                }
            } catch {
                print("Error fetching meals: \(error)")
            }
        }
    }
}
