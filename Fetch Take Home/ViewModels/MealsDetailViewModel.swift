//
//  MealDetailViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

@MainActor
class MealsDetailViewModel: ObservableObject {
    @Published var meal: Meal
    @Published var isLoading: Bool = false
    @Published var recipe: MealsResponse?
    @Published var errorMessage: String?
    private var services: MealServiceProtocol
    
    init(meal: Meal, services: MealServiceProtocol = Services()) {
        self.meal = meal
        self.services = services
    }
    
    func fetch() {
        isLoading = true
        Task {
            do {
                let recipeData = try await services.lookup(id: meal.id)
                recipe = recipeData
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
