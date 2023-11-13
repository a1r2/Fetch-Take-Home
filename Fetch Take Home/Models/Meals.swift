//
//  Meals.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import Foundation

// MARK: - Meals
struct Meals: Decodable {
    var meals: [Meal]
}

// MARK: - Meal
struct Meal: Decodable, Hashable, Identifiable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String

    // Conformance to Identifiable
    var id: String { idMeal }
    
    private enum CodingKeys: String, CodingKey {
        case strMeal, strMealThumb, idMeal
    }

    // Custom Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode each property, providing a default value if the property is missing or empty
        strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal) ?? "Unknown Meal"
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb) ?? "Unknown Thumb"
        idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal) ?? "Unknown ID"
    }
    
    // Standard initializer for direct creation or mock data
    init(strMeal: String, strMealThumb: String, idMeal: String) {
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.idMeal = idMeal
    }

}
