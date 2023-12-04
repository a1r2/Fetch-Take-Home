//
//  MealViewModelTests.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/2/23.
//

import XCTest
@testable import Fetch_Take_Home

final class MealsViewModelTests: XCTestCase {
    
    let meals = Meals(meals: [
        Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
    ])
    
    func test_Initial_State() {
        // Arrange
        
        // Act
        let viewModel = MealsViewModel()
        
        // Assert
        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_when_Succeeds() async {
        // Arrange
        let mock = MockMealServiceProtocol(categoryResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(viewModel.meals.count > 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_when_Fails() async {
        // Arrange
        let mock = MockMealServiceProtocol(error: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealsViewModel(service: mock)

        // Act
        await viewModel.fetch()

        // Assert
        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertEqual(viewModel.errorMessage, "some error")
    }
}
