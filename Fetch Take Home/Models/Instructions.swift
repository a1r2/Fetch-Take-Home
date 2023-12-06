//
//  Instructions.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import Foundation

struct Instructions: Decodable, Equatable {
    let meals: [Recipe]
}

struct Recipe: Decodable, Hashable {
    let strArea: String?
    let strTags: String?
    let strMealThumb: String?
    let strCreativeCommonsConfirmed: String?
    let strMeal: String?
    let strImageSource: String?
    let strSource: String?
    let strInstructions: String?
    let idMeal: String?
    let dateModified: String?
    let strYoutube: String?
    let strCategory: String?
    let strDrinkAlternate: String?
    let ingredients: [String: String]
}

extension Recipe {
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Decode known keys
        // Safely unwrap the key
        strArea = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strArea"))
        strTags = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strTags"))
        strMealThumb = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strMealThumb"))
        strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strCreativeCommonsConfirmed"))
        strMeal = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strMeal"))
        strImageSource = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strImageSource"))
        strSource = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strSource"))
        strInstructions = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strInstructions"))
        idMeal = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "idMeal"))
        dateModified = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "dateModified"))
        strYoutube = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strYoutube"))
        strCategory = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strCategory"))
        strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: "strDrinkAlternate"))
        
        // Handle dynamic keys for ingredients and measurements
        var dicIngredients: [String: String] = [:]
        
        for i in 1...30 { // Adjust range as needed
            let ingredientKey = DynamicCodingKeys(stringValue: "strIngredient\(i)")
            guard let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey), !ingredient.isEmpty
            else { break }
            
            let measureKey = DynamicCodingKeys(stringValue: "strMeasure\(i)")
            guard let measure = try container.decodeIfPresent(String.self, forKey: measureKey),!measure.isEmpty
            else { break }
            
            dicIngredients[ingredient] = measure
        }
        
        ingredients = dicIngredients
    }
}
