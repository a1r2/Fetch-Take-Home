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
    @Published private(set) var recipe: Instructions?
    @Published private(set) var errorMessage: String?
    private var service: MealServiceProtocol
    
    init(meal: Meal, service: MealServiceProtocol = Service()) {
        self.meal = meal
        self.service = service
    }
    
    @MainActor
    func fetch(idOverride: String? = nil) async {
        let idToFetch = idOverride ?? meal.idMeal
        errorMessage = nil
        state = .loading
        do {
            let recipeData = try await service.lookup(id: idToFetch)
            recipe = recipeData
            state = .idle
        } catch {
            errorMessage = error.localizedDescription
            state = .error
        }
    }
}
