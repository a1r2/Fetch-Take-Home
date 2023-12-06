//
//  MealDetailViewModelTests.swift
//  Fetch Take HomeTests
//
//  Created by Adriano Ramos on 12/2/23.
//

import XCTest
import Combine
@testable import Fetch_Take_Home

final class MealDetailViewModelTests: XCTestCase {
    
    let mealsResponse = Instructions(
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
    
    func test_Initial_State() {
        // Arrange
        let meal = Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
        let viewModel = MealDetailViewModel(meal: meal)
        
        // Act
        
        // Assert
        XCTAssertEqual(viewModel.meal, meal)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertNil(viewModel.recipe)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_when_Succeeds() async {
        // Arrange
        let meal = Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
        let mock = MockMealServiceProtocol(outputLookupResult: mealsResponse)
        let viewModel = MealDetailViewModel(meal: meal, service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertEqual(viewModel.recipe, mealsResponse)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetch_when_Fails() async {
        // Arrange
        let meal = Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
        let mock = MockMealServiceProtocol(outputError: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealDetailViewModel(meal: meal, service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertNil(viewModel.recipe)
        XCTAssertEqual(viewModel.state, .error)
        XCTAssertEqual(viewModel.errorMessage, "some error")
    }
    
    func test_Initial_meal_idMeal() async {
        // Arrange
        let meal = Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
        let mock = MockMealServiceProtocol(outputLookupResult: mealsResponse)
        let viewModel = MealDetailViewModel(meal: meal, service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertEqual(mock.inputLookupId, "idMeal")
    }
    
    func test_State_Loading_WhenFetching() async {
        // Arrange
        let meal = Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
        let mock = MockMealServiceProtocol(outputLookupResult: mealsResponse)
        let viewModel = MealDetailViewModel(meal: meal, service: mock)
        
        var cancellables = Set<AnyCancellable>()
        var changedToLoading = false
        var changedErrorToNil = false
        
        viewModel.$state
            .dropFirst()
            .sink { state in
                if state == .loading {
                    changedToLoading = true
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage == nil {
                    changedErrorToNil = true
                }
            }
            .store(in: &cancellables)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(changedToLoading)
        XCTAssertTrue(changedErrorToNil)
    }
}
