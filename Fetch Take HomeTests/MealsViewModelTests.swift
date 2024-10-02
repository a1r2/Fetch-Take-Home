import XCTest
import Combine
@testable import Fetch_Take_Home

final class MealsViewModelTests: XCTestCase {
    
    // Sample data for tests
    let meals = Meals(meals: [
        Meal(strMeal: "strMeal", strMealThumb: "strMealThumb", idMeal: "idMeal")
    ])
    
    func test_Initial_State() {
        // Arrange
        let viewModel = MealsViewModel()
        
        // Act
        
        // Assert
        XCTAssertTrue(viewModel.meals.isEmpty, "Meals should be empty initially.")
        XCTAssertEqual(viewModel.state, .idle, "Initial state should be idle.")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil initially.")
    }
    
    func test_fetch_when_Succeeds() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputCategoriesResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(viewModel.meals.count > 0, "Meals should be populated on successful fetch.")
        XCTAssertEqual(viewModel.state, .idle, "State should be idle after successful fetch.")
        XCTAssertNil(viewModel.errorMessage, "Error message should be nil after successful fetch.")
        XCTAssertTrue(mock.inputCategoriesCategory == "Dessert", "The category should be 'Dessert'.")
    }
    
    func test_fetch_when_Fails() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputError: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(viewModel.meals.isEmpty, "Meals should be empty when fetching fails.")
        XCTAssertEqual(viewModel.state, .error, "State should be error when fetching fails.")
        XCTAssertEqual(viewModel.errorMessage, "some error", "Error message should match the expected error.")
    }
    
    func test_InitialCategoryIsDessert() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputCategoriesResult: meals)
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertEqual(mock.inputCategoriesCategory, "Dessert", "Initial fetch should request 'Dessert' category.")
    }
    
    func testSortingLogic() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputCategoriesResult: Meals(meals: [
            Meal(strMeal: "Pizza", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Apple", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Burger", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Spaghetti", strMealThumb: "", idMeal: "")
        ]))
        let viewModel = MealsViewModel(service: mock)
        
        // Act
        await viewModel.fetch()
        
        // Define the expected order based on the sorting logic
        let expectedOrder: [Meal] = [
            Meal(strMeal: "Apple", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Burger", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Pizza", strMealThumb: "", idMeal: ""),
            Meal(strMeal: "Spaghetti", strMealThumb: "", idMeal: "")
        ]
        
        // Assert that the meals are sorted correctly
        XCTAssertEqual(viewModel.meals, expectedOrder, "Meals should be sorted in alphabetical order.")
    }

    func test_State_Error_WhenFetching() async {
        // Arrange
        let mock = MockMealServiceProtocol(outputError: NSError(domain: "domain", code: 1, userInfo: [NSLocalizedDescriptionKey : "some error"]))
        let viewModel = MealsViewModel(service: mock)
        
        // Setup cancellables to track state changes
        var cancellables = Set<AnyCancellable>()
        var changedToError = false
        var changedErrorMessage = false
        
        // Observe state changes
        viewModel.$state
            .dropFirst()
            .sink { state in
                if state == .error {
                    changedToError = true
                }
            }
            .store(in: &cancellables)
        
        // Observe error message changes
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage != nil {
                    changedErrorMessage = true
                }
            }
            .store(in: &cancellables)
        
        // Act
        await viewModel.fetch()
        
        // Assert
        XCTAssertTrue(changedToError, "State should change to error when fetching fails.")
        XCTAssertTrue(changedErrorMessage, "Error message should be updated when fetching fails.")
    }
}
