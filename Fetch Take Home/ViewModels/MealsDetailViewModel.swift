//
//  MealDetailViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

@MainActor
class MealsDetailViewModel: ObservableObject {
    @Published private(set) var meal: Meal
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var recipe: MealsResponse?
    @Published private(set) var errorMessage: String?
    private var services: MealServiceProtocol = Services()
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    func fetch() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let recipeData = try await services.lookup(id: meal.idMeal)
                recipe = recipeData
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
