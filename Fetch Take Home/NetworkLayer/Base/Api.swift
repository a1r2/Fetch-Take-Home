import Foundation

// MARK: - Protocol Api

/// The `Api` protocol defines a set of requirements for creating and handling API requests.
protocol Api {
    /// Headers specific to the current API request.
    var headers: [String: String] { get }

    /// Headers that are shared across all API requests.
    var sharedHeaders: [String: String] { get }
        
    /// URL components for the API request.
    var components: URLComponents { get }
    
    /// Full URL for the API request.
    var fullUrl: URL { get }
    
    /// URLRequest for the API request.
    var urlRequest: URLRequest { get }
        
    /// HTTP method for the API request.
    var method: HttpMethod { get }
    
    /// Base URL for the API request.
    var baseUrl: BaseUrl { get }
    
    /// Path for the API request.
    var path: String { get }
    
    /// Query items for the API request.
    var queryItems: [URLQueryItem]? { get }
    
    /// Body data for the API request.
    var body: Data? { get }
    
    /// Api methods
    func request(print: Bool) async throws -> (Data, StatusCode)
    func requestData<T: Decodable>(_ responseType: T.Type, print: Bool) async throws -> T
    func decodeResponse<T: Decodable>(_ responseType: T.Type, data: Data, statusCode: Int) throws -> T
}

extension Api {
    var sharedHeaders: [String: String] {
        var headerFields = ["User-Agent": "iPhone"]
        headerFields["Authorization"] = "Token"
        
        switch self.method {
        case .POST, .PUT:
            headerFields["Content-Type"] = "application/json"
            return headerFields
        default: return headerFields
        }
    }
    
    var headers: [String: String] {
        return self.sharedHeaders
    }
    
    var components: URLComponents {
        var urlComponents = self.baseUrl.components
        urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems
        return urlComponents
    }
    
    var fullUrl: URL {
        guard let url = self.components.url else {
            fatalError(MyApiError.invalidUrl(nil).localizedDescription)
        }
        return url
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: self.fullUrl)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.body
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        return request
    }
    
    typealias StatusCode = Int
    
    func request(print: Bool) async throws -> (Data, StatusCode) {
        do {
            let (data, response) = try await URLSession.shared.data(for: self.urlRequest)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            let httpStatus = HttpStatus(rawValue: statusCode) ?? .noData
            if print {
                Factory.log(request: urlRequest, data: data, response: response)
            }
            guard httpStatus.isSuccessful else {
                throw httpStatus.error
            }
            return (data, statusCode)
        } catch let error {
            throw error is MyError ? error : HttpError.requestFailure(error)
        }
    }
    
    func requestData<T: Decodable>(_ responseType: T.Type, print: Bool) async throws -> T {
        let (data, statusCode) = try await request(print: print)
        return try decodeResponse(responseType, data: data, statusCode: statusCode)
    }
    
    func decodeResponse<T: Decodable>(_ responseType: T.Type, data: Data, statusCode: Int) throws -> T {
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch let error {
            throw MyApiError.decodeFailed(error)
        }
    }
    
}
