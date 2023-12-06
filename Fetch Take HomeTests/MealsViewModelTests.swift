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
    
    
    // Helper function to create a sample meal
        func createMeal(name: String) -> Meal {
            return Meal(strMeal: name, strMealThumb: "", idMeal: "")
        }
        
        func testSortingLogic() {
            // Arrange
            let viewModel = MealsViewModel()
            
            let sampleMeals: [Meal] = [
                createMeal(name: "Pizza"),
                createMeal(name: "Burger"),
                createMeal(name: "Spaghetti"),
                createMeal(name: "Apple"),
                createMeal(name: "Banana")
            ]
            
//            // Act
//            viewModel.meals = sampleMeals
//            let sortedMeals = viewModel.sort(viewModel.meals)
//            
//            // Assert
//            // Define the expected order based on the sorting logic
//            let expectedOrder: [String] = ["Apple", "Banana", "Burger", "Pizza", "Spaghetti"]
//            
//            // Extract meal names from sortedMeals
//            let sortedMealNames = sortedMeals.map { $0.strMeal }
//            
//            // Verify that the sortedMealNames match the expectedOrder
//            XCTAssertEqual(sortedMealNames, expectedOrder)
        }
    
}
