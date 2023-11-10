import Foundation

enum HttpError: LocalizedError {
    case error(HttpStatus)
    case requestFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .error(let status): return getMessage(for: status)
        case .requestFailure(let err): return "session.data(for:) error: \(err.localizedDescription)"
        }
    }
    
    private func getMessage(for httStatus: HttpStatus) -> String {
        switch httStatus {
        case .multipleChoices: return "Response has multiple choices"
        default: return "No data"
        }
    }
}
