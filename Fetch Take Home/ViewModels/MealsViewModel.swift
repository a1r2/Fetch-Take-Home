//
//  MealViewModel.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

@MainActor
class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var services: MealServiceProtocol
    
    init(services: MealServiceProtocol = Services()) {
        self.services = services
    }
    
    func fetch() {
        isLoading = true
        Task {
            do {
                let mealsData = try await services.categories(category: "Dessert")
                meals = mealsData.meals.sorted {
                    $0.strMeal.lowercased() < $1.strMeal.lowercased()
                }
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
