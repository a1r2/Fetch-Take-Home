import Foundation

enum NetworkError: Error {
    case invalidResponse
    case unexpectedStatusCode(Int)
    case requestFailure(Error)
    case invalidUrl(_ url: URL?)
    case urlNotInPlist(_ key: String?)
    case decodeFailed(_ err: Error)
    case noNetwork(_ key: String?)
    case httpError(HttpStatus)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response received from the server"
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected status code: \(statusCode)"
        case .requestFailure(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .invalidUrl(let url):
            return "Invalid Url: \(url?.absoluteString ?? "Empty")"
        case .urlNotInPlist(let key):
            return "Failed to retrieve url with key: \(String(describing: key)) from plist"
        case .decodeFailed(let err):
            return "Failed to decode response: \(err.localizedDescription)"
        case .noNetwork(let key):
            return "Check your connection: \(String(describing: key))"
        case .httpError(let status):
            return "HTTP Error: \(status.userFriendlyDescription)"
        }
    }
}
