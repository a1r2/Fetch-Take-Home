import SwiftUI

enum FetchApi: Api {

    case meals(category: String)

    var method: HttpMethod { .GET }

    var baseUrl: BaseUrl { .service(.host) }

    var path: String {
        switch self {
        case .meals(_ ):
            return "/api/json/v1/1/filter.php"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .meals(let category):
            return [
                URLQueryItem(name: "c", value: String(category))
            ]
        }
    }

    var body: Data? { nil }

}
