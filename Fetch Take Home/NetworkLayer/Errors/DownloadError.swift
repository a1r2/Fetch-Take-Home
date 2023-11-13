import Foundation

enum DownloadError: Error {
    case downloadFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .downloadFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        }
    }
}
