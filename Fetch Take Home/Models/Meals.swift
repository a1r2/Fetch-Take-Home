//
//  Meals.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import Foundation

// MARK: - Meals
struct Meals: Decodable, Equatable {
    let meals: [Meal]
}

// MARK: - Meal
struct Meal: Decodable, Hashable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
