import Foundation

protocol MealServiceProtocol {
    func categories(category: String) async throws -> Meals
    func lookup(id: String) async throws -> MealsResponse
}

class Services: MealServiceProtocol {
    func categories(category: String) async throws -> Meals {
        try await FetchApi.filter(category: category).requestData(Meals.self, print: false)
    }
    func lookup(id: String) async throws -> MealsResponse {
        try await FetchApi.lookup(id: id).requestData(MealsResponse.self, print: false)
    }
}
