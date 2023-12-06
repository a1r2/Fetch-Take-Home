//
//  MockMealServiceProtocol.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/3/23.
//

import Foundation
@testable import Fetch_Take_Home

class MockMealServiceProtocol: MealServiceProtocol {
    let categoryResult: Meals?
    let lookupResult: Instructions?
    let error: Error?
    
    init(categoryResult: Meals? = nil, lookupResult: Instructions? = nil, error: Error? = nil) {
        self.categoryResult = categoryResult
        self.lookupResult = lookupResult
        self.error = error
    }
    
    func categories(category: String) async throws -> Meals {
        if let error {
            throw error
        }
        // Return a valid Meals object (assuming Meals is a collection of Meal)
        return Meals(
            meals: [
                Meal(
                    strMeal: "strMeal",
                    strMealThumb: "strMealThumb",
                    idMeal: "idMeal"
                )
            ]
        )
    }
    
    
    func lookup(id: String) async throws -> Instructions {
        if let error {
            throw error
        }
        return Instructions(
            meals: [
                Recipe(
                    strArea: "strArea",
                    strTags: "strTags",
                    strMealThumb: "strMealThumb",
                    strCreativeCommonsConfirmed: "strCreativeCommonsConfirmed",
                    strMeal: "strMeal",
                    strImageSource: "strImageSource",
                    strSource: "strSource",
                    strInstructions: "strInstructions",
                    idMeal: "strCategory",
                    dateModified: "dateModified",
                    strYoutube: "strYoutube",
                    strCategory: "strCategory",
                    strDrinkAlternate: "strDrinkAlternate",
                    ingredients: ["": ""]
                )
            ]
        )
    }
}
