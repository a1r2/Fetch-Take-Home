//
//  MealsResponse.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import Foundation

struct MealsResponse: Decodable {
    var meals: [FollowThisRecipe]
}

struct FollowThisRecipe: Decodable {
    var strArea: String?
    var strTags: String?
    var strMealThumb: String?
    var strCreativeCommonsConfirmed: String?
    var strMeal: String?
    var strImageSource: String?
    var strSource: String?
    var strInstructions: String?
    var idMeal: String?
    var dateModified: String?
    var strYoutube: String?
    var strCategory: String?
    var strDrinkAlternate: String?
    var ingredients: [String: String] = [:]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Decode known keys
        // Safely unwrap the key
        if let key = DynamicCodingKeys(stringValue: "strArea") {
            strArea = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strTags") {
            strTags = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strMealThumb") {
            strMealThumb = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strCreativeCommonsConfirmed") {
            strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strMeal") {
            strMeal = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strImageSource") {
            strImageSource = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strSource") {
            strSource = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strInstructions") {
            strInstructions = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "idMeal") {
            idMeal = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "dateModified") {
            dateModified = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strYoutube") {
            strYoutube = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strCategory") {
            strCategory = try container.decodeIfPresent(String.self, forKey: key)
        }
        if let key = DynamicCodingKeys(stringValue: "strDrinkAlternate") {
            strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: key)
        }
        
        // Handle dynamic keys for ingredients and measurements
        for i in 1...30 { // Adjust range as needed
            if let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)"),
               let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)") {
                if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
                   !ingredient.isEmpty {
                    let measure = try container.decodeIfPresent(String.self, forKey: measureKey) ?? ""
                    ingredients[ingredient] = measure
                }
            }
        }
    }
    
    // Standard initializer
     init(strArea: String?, strTags: String?, strMealThumb: String?, strCreativeCommonsConfirmed: String?, strMeal: String?, strImageSource: String?, strSource: String?, strInstructions: String?, idMeal: String?, dateModified: String?, strYoutube: String?, strCategory: String?, strDrinkAlternate: String?, ingredients: [String: String]) {
         self.strArea = strArea
         self.strTags = strTags
         self.strMealThumb = strMealThumb
         self.strCreativeCommonsConfirmed = strCreativeCommonsConfirmed
         self.strMeal = strMeal
         self.strImageSource = strImageSource
         self.strSource = strSource
         self.strInstructions = strInstructions
         self.idMeal = idMeal
         self.dateModified = dateModified
         self.strYoutube = strYoutube
         self.strCategory = strCategory
         self.strDrinkAlternate = strDrinkAlternate
         self.ingredients = ingredients
     }
}
