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
    var plistValue: String {
        guard let plistKey = plistKey else { return "" }
        guard let endpoint = Bundle.getFromPlist(key: plistKey) else {
            fatalError(MyApiError.urlNotInPlist(plistKey).localizedDescription)
        }
        
        switch self {
        case .service:
            return endpoint
        }
    }
    
    /// The host for the API request.
    var host: String {
        switch self {
        default: 
            return self.plistValue.isEmpty ? "Host is missing!" : self.plistValue
        }
    }
    
    /// The URLComponents for the API request.
    var components: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.host
        return urlComponents
    }
}
