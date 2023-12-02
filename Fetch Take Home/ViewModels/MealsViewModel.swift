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
    @Published private(set) var state: FetchDataState = .Loaded
    @Published private(set) var errorMessage: String?
    private var services: MealServiceProtocol = Services()
    
    func fetch() {
        state = .Loading
        errorMessage = nil
        Task {
            do {
                let mealsData = try await services.categories(category: "Dessert")
                meals = mealsData.meals.sorted {
                    $0.strMeal.lowercased() < $1.strMeal.lowercased()
                }
                state = .Loaded
            } catch {
                errorMessage = error.localizedDescription
                state = .Error
            }
        }
    }
}
