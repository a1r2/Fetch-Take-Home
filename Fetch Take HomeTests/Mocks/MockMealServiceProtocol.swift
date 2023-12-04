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
    let lookupResult: MealsResponse?
    let error: Error?
    
    init(categoryResult: Meals? = nil, lookupResult: MealsResponse? = nil, error: Error? = nil) {
        self.categoryResult = categoryResult
        self.lookupResult = lookupResult
        self.error = error
    }
    
    func categories(category: String) async throws -> Meals {
        if let error {
            throw error
        }
        return categoryResult!
    }
    
    func lookup(id: String) async throws -> MealsResponse {
        if let error {
            throw error
        }
        return lookupResult!
    }
}
