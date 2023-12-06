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
    private(set) var category: String
    private(set) var service: MealServiceProtocol
    private(set) var sort: ([Meal]) -> [Meal]
    
    init(category: String = "Dessert", service: MealServiceProtocol = Service(), sort: @escaping ([Meal]) -> [Meal] = { meals in
        return meals.sorted {
            $0.strMeal.lowercased() < $1.strMeal.lowercased()
        }
    }) {
        self.category = category
        self.service = service
        self.sort = sort
    }

    @MainActor
    func fetch(categoryOverride: String? = nil) async {
        let categoryToFetch = categoryOverride ?? category
        errorMessage = nil
        state = .loading
        do {
            let mealsData = try await service.categories(category: categoryToFetch)
            meals = sort(mealsData.meals)
            state = .idle
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }
}
