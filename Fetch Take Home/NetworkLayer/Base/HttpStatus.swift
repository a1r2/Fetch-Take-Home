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

// Updated extension for HttpStatus to provide user-friendly descriptions
extension HttpStatus {
    var userFriendlyDescription: String {
        switch self {
        case .ok:
            return "OK - Request successful"
        case .created:
            return "Created - Request successfully created"
        case .accepted:
            return "Accepted - Request accepted for processing"
        case .multipleChoices:
            return "Multiple Choices - There are multiple options"
        case .restricted:
            return "Restricted - Access is restricted"
        case .serviceRestricted:
            return "Service Restricted - Access to the service is restricted"
        case .noData:
            return "No Data - No data available"
        }
    }
}
