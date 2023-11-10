import Foundation

enum MyApiError: LocalizedError {
    case invalidUrl(_ url: URL?)
    case urlNotInPlist(_ key: String?)
    case decodeFailed(_ err: Error)
    case noNetwork(_ key: String?)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl(let url):
            return "Invalid Url: \(url?.absoluteString ?? "Empty")"
        case .urlNotInPlist(let key):
            return "Failed to retrieve url with key: \(String(describing: key)) from plist"
        case .decodeFailed(let err):
            return "Failed to decode response: \(err.localizedDescription)"
        case .noNetwork(let key):
            return "Check you connection: \(String(describing: key))"
        }
    }
}

enum DownloadError: Error {
    case downloadFailed(Error)
}
