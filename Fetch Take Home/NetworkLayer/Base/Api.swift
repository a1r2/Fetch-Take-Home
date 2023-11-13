import Foundation

// MARK: - Protocol Api

/// The `Api` protocol defines a set of requirements for creating and handling API requests.
protocol Api {
    /// Headers specific to the current API request.
    var headers: [String: String] { get }
    
    /// URL components for the API request.
    var components: URLComponents { get }
    
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
    
    /// Performs the API request and returns the data and status code.
    func request(print: Bool) async throws -> (Data, StatusCode)
    
    /// Requests data and decodes it into the specified Decodable type.
    func requestData<T: Decodable>(_ responseType: T.Type, print: Bool) async throws -> T
    
    /// Decodes the response data into the specified Decodable type.
    func decodeResponse<T: Decodable>(_ responseType: T.Type, data: Data) throws -> T
}

// MARK: - Extension for Shared Functionality

extension Api {
    /// Shared headers that are common across all API requests.
    var sharedHeaders: [String: String] {
        ["User-Agent": "iPhone", "Authorization": "Token"]
    }
    
    /// Combines shared headers with headers specific to the API request.
    var headers: [String: String] {
        var allHeaders = sharedHeaders
        if method == .POST || method == .PUT {
            allHeaders["Content-Type"] = "application/json"
        }
        return allHeaders
    }
    
    /// Constructs the full URL components for the API request.
    var components: URLComponents {
        var urlComponents = baseUrl.components
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    /// Constructs the URLRequest for the API request.
    var urlRequest: URLRequest {
        guard let url = components.url else {
            fatalError(NetworkError.invalidUrl(nil).localizedDescription)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
    
    typealias StatusCode = Int
    
    func request(print: Bool) async throws -> (Data, StatusCode) {
        do {
            let (data, response) = try await URLSession.shared.data(for: self.urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            let statusCode = httpResponse.statusCode
            
            // Using HttpStatus to handle status codes
            if let httpStatus = HttpStatus(rawValue: statusCode), !httpStatus.isSuccessful {
                throw NetworkError.httpError(httpStatus)
            }
            
            // Logging, if required
            if print {
                Factory.log(request: urlRequest, data: data, response: response)
            }
            
            // Success case
            return (data, statusCode)
            
        } catch let error as NetworkError {
            // NetworkError is thrown directly
            throw error
        } catch {
            // Other errors are wrapped in NetworkError.requestFailure
            throw NetworkError.requestFailure(error)
        }
    }
    
    func requestData<T: Decodable>(_ responseType: T.Type, print: Bool) async throws -> T {
        let (data, _) = try await request(print: print)
        return try decodeResponse(responseType, data: data)
    }
    
    func decodeResponse<T: Decodable>(_ responseType: T.Type, data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch let error {
            throw NetworkError.decodeFailed(error)
        }
    }
    
}
