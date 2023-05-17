import Foundation

enum AppError: Error {
    
    case failedRequest
    case invalidResponse
    case unreachable
    case unknown
    case invalid(String)
    
    var message: String {
        switch self {
        case .unreachable:
            return "Check your internet connection and try again"
        case .failedRequest,
                .invalidResponse:
            return "Unable to fetch countries. Try later"
        case .unknown:
            return "Unknown error"
        case .invalid(let message):
            return message
        }
    }
    
}
