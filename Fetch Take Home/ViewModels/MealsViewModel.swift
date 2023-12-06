//
//  MealViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

class MealsViewModel: ObservableObject {
    @Published private(set) var meals: [Meal] = []
    @Published private(set) var state: FetchDataState = .idle
    @Published private(set) var errorMessage: String?
    @Published private(set) var category: String = "Dessert"
    private var service: MealServiceProtocol
    
    init(service: MealServiceProtocol = Service()) {
        self.service = service
    }

    @MainActor
    func fetch(categoryOverride: String? = nil) async {
        let categoryToFetch = categoryOverride ?? category
        errorMessage = nil
        state = .loading
        do {
            let mealsData = try await service.categories(category: categoryToFetch)
            meals = sortMealsByName(meals: mealsData.meals)
            state = .idle
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }
    
    func sortMealsByName(meals: [Meal]) -> [Meal] {
        return meals.sorted {
            $0.strMeal.lowercased() < $1.strMeal.lowercased()
        }
    }
}
