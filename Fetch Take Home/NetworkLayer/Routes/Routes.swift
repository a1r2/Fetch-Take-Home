import SwiftUI

enum FetchApi: Api {    
    
    case filter(category: String)
    case lookup(id: String)

    var method: HttpMethod { .GET }

    var baseUrl: BaseUrl { .service(.host) }

    var path: String {
        switch self {
        case .filter:
            return "/api/json/v1/1/filter.php"
        case .lookup:
            return "/api/json/v1/1/lookup.php"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .filter(let category):
            return [
                URLQueryItem(name: "c", value: String(category))
            ]
        case .lookup(let id):
            return [
                URLQueryItem(name: "i", value: String(id))
            ]
        }
    }

    var body: Data? { nil }

}
