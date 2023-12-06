//
//  MockMealServiceProtocol.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/3/23.
//

import Foundation
@testable import Fetch_Take_Home

class MockMealServiceProtocol: MealServiceProtocol {
    let outputCategoriesResult: Meals?
    let outputLookupResult: Instructions?
    let outputError: Error?
    var inputCategoriesCategory: String?
    var inputLookupId: String?
    
    init(outputCategoriesResult: Meals? = nil, outputLookupResult: Instructions? = nil, outputError: Error? = nil) {
        self.outputCategoriesResult = outputCategoriesResult
        self.outputLookupResult = outputLookupResult
        self.outputError = outputError
    }
    
    func categories(category: String) async throws -> Meals {
        self.inputCategoriesCategory = category
        if let outputError {
            throw outputError
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
        self.inputLookupId = id
        if let outputError {
            throw outputError
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
