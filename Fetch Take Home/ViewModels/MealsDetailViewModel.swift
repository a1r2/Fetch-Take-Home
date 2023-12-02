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
    @Published private(set) var state: FetchDataState = .Loaded
    @Published private(set) var recipe: MealsResponse?
    @Published private(set) var errorMessage: String?
    private var services: MealServiceProtocol = Services()
    
    init(meal: Meal) {
        self.meal = meal
    }
    
    func fetch() {
        state = .Loading
        errorMessage = nil
        Task {
            do {
                let recipeData = try await services.lookup(id: meal.idMeal)
                recipe = recipeData
                state = .Loaded
            } catch {
                errorMessage = error.localizedDescription
                state = .Error
            }
        }
    }
}
