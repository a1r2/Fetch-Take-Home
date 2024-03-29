//
//  MealViewModelTests.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/2/23.
//

import XCTest
import Combine
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
        let mock = MockMealServiceProtocol(outputCategoriesResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(viewModel.meals.count > 0)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(mock.inputCategoriesCategory == "Dessert")
    }
    
    func test_fetch_when_Fails() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputError: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertEqual(viewModel.errorMessage, "some error")
    }
    
    func test_InitialCategoryIsDessert() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputCategoriesResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertEqual(mock.inputCategoriesCategory, "Dessert")
    }
    
    func testSortingLogic() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputCategoriesResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        // Define the expected order based on the sorting logic
        let expectedOrder: [Meal] = [
            Meal(strMeal: "Apple", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Burger", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Pizza", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Spaghetti", strMealThumb: "", idMeal: "")
        ]
                
        // Verify that the sorted arrays match
        XCTAssertEqual(expectedOrder, viewModel.meals)
    }

    func test_State_Error_WhenFetching() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputError: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealsViewModel(service: mock)
        
        var cancellables = Set<AnyCancellable>()
        var changedToError = false
        var changedErrorMessage = false
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                dump(state)
                if state == .error {
                    changedToError = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                dump(errorMessage)
                if errorMessage != nil {
                    changedErrorMessage = true
                }
            }
            .store(in: &cancellables)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(changedToError)
        XCTAssertTrue(changedErrorMessage)
    }
}
