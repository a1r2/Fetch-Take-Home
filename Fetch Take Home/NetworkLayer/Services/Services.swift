import Foundation

protocol MealServiceProtocol {
    func categories(category: String) async throws -> Meals
    func lookup(id: String) async throws -> Instructions
}

extension MealServiceProtocol {
    func categories(category: String) async throws -> Meals {
        try await FetchApi.filter(category: category).requestData(Meals.self, print: false)
    }
    func lookup(id: String) async throws -> Instructions {
        try await FetchApi.lookup(id: id).requestData(Instructions.self, print: true)
    }
}

class Service: MealServiceProtocol { }
