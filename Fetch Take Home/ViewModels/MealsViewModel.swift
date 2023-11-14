//
//  MealViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

@MainActor
class MealsViewModel: ObservableObject {
    @Published private(set) var meals: [Meal] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    private var services: MealServiceProtocol = Services()
    
    func fetch() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let mealsData = try await services.categories(category: "Dessert")
                meals = mealsData.meals.sorted {
                    $0.strMeal.lowercased() < $1.strMeal.lowercased()
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
