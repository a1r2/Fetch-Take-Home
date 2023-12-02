//
//  MealsViewModelTests.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/2/23.
//

import XCTest
@testable import Fetch_Take_Home

// Mock implementation of MealServiceProtocol for testing
class MockMealService: MealServiceProtocol {
    var mockCategoriesResult: Result<Meals, Error>?
    
    func categories(category: String) async throws -> Meals {
        guard let result = mockCategoriesResult else {
            throw NSError(domain: "MockDomain", code: 456, userInfo: nil)
        }
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

@MainActor
class MealsViewModelTests: XCTestCase {
    
    var viewModel: MealsViewModel!
    var mockService: MockMealService!
    
    override func setUp() {
        super.setUp()
        mockService = MockMealService()
        viewModel = MealsViewModel()
        viewModel.services = mockService
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // Test the fetch() method when data is successfully fetched.
    func testFetchSuccess() {
        // Set up mock data and expectations
        let mockMeals = [Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")]
        mockService.mockCategoriesResult = .success(Meals(meals: mockMeals))
        
        // Call the fetch method
        viewModel.fetch()
        
        // Check the state after fetch
        XCTAssertEqual(viewModel.state, .Loaded)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.meals, mockMeals.sorted { $0.strMeal.lowercased() < $1.strMeal.lowercased() })
    }
    
    // Test the fetch() method when there is an error.
    func testFetchError() {
        // Set up mock error and expectations
        let mockError = NSError(domain: "TestDomain", code: 123, userInfo: nil)
        mockService.mockCategoriesResult = .failure(mockError)
        
        // Call the fetch method
        viewModel.fetch()
        
        // Check the state after fetch
        XCTAssertEqual(viewModel.state, .Error)
        XCTAssertEqual(viewModel.errorMessage, mockError.localizedDescription)
        XCTAssertTrue(viewModel.meals.isEmpty)
    }

}
