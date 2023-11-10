import Foundation

class Services {
    static func categories(category: String) async throws -> Meals {
        try await FetchApi.meals(category: category).requestData(Meals.self, print: true)
    }
}
