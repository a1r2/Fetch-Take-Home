// The HttpStatus enum represents different HTTP status codes and provides utility methods for checking success, retrieving success messages, and error handling.
enum HttpStatus: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case multipleChoices = 300
    case restricted = 301
    case serviceRestricted = 307
    case noData
    
    var isSuccessful: Bool {
        switch self {
        case .ok, .created, .accepted: 
            return true
        default: 
            return false
        }
    }
    
    var successMessage: String? {
        switch self {
        case .ok: 
            return "Request successful"
        case .accepted: 
            return "Request accepted"
        case .created: 
            return "Request created"
        default: 
            return nil
        }
    }
    
    var isRestricted: Bool {
        self == .restricted || self == .serviceRestricted
    }
    
    var error: Error {
        HttpError.error(self)
    }
}
