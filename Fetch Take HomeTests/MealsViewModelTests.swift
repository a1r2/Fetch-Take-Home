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
        let viewModel = MealsViewModel()
        
        // Act
        
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
    
    func test_InitialCategoryIsDessert() {
        // Arrange
        let viewModel = MealsViewModel()
        
        // Act
        
        // Assert
        XCTAssertEqual(viewModel.category, "Dessert")
    }
    
    
    func testSortingLogicUnchanged() {
        // Arrange
        let viewModel = MealsViewModel()
        
        let sortingClosure = { (meal1: Meal, meal2: Meal) in
            return meal1.strMeal.lowercased() < meal2.strMeal.lowercased()
        }
        
        // Helper function to create a sample meal
        func createMeal(name: String) -> Meal {
            return Meal(strMeal: name, strMealThumb: "", idMeal: "")
        }
        
        let sampleMeals: [Meal] = [
            createMeal(name: "Burger"),
            createMeal(name: "Pizza"),
            createMeal(name: "Spaghetti"),
            createMeal(name: "apple"),
            createMeal(name: "banana")
        ]
        
        // Act
        // Sort the sample meals using the sorting closure
        let sortedByClosure = sampleMeals.sorted(by: sortingClosure)
        // Sort the sample meals using the viewModel logic
        let sortedByViewModel = viewModel.sortMealsByName(meals: sampleMeals)
        
        // Assert
        XCTAssertEqual(sortedByClosure, sortedByViewModel)
    }
    
}
