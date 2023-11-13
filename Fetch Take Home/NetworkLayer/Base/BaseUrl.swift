import Foundation

/// The BaseUrl enum represents different base URLs for API requests, with support for retrieving values from the Info.plist file.
enum BaseUrl {
    case service(_ host: Host)
    
    /// The key in the Info.plist file corresponding to the base URL.
    var plistKey: String? {
        switch self {
        case .service:
            return "HOST_KEY"
        }
    }
    
    /// The value retrieved from the Info.plist file using the plistKey.
    var plistValue: String? {
        guard let plistKey = plistKey,
              let endpoint = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String else {
            return nil
        }
        return endpoint
    }
    
    /// The host for the API request.
    var host: String {
        switch self {
        case .service:
            guard let host = self.plistValue else {
                return "Host is missing!"
            }
            return host
        }
    }
    
    /// The URLComponents for the API request.
    var components: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https" // Consider making this configurable if needed
        urlComponents.host = self.host
        return urlComponents
    }
}
