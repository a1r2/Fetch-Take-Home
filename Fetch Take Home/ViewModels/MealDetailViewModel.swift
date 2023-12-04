//
//  MealDetailViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

class MealDetailViewModel: ObservableObject {
    @Published private(set) var meal: Meal
    @Published private(set) var state: FetchDataState = .idle
    @Published private(set) var recipe: MealsResponse?
    @Published private(set) var errorMessage: String?
    private var service: MealServiceProtocol
    
    init(meal: Meal, service: MealServiceProtocol = Service()) {
        self.meal = meal
        self.service = service
    }
    
    @MainActor
    func fetch() async {
        errorMessage = nil
        state = .loading
        do {
            let recipeData = try await service.lookup(id: meal.idMeal)
            recipe = recipeData
            state = .idle
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }
}
