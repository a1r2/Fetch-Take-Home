import Foundation

protocol MyError: LocalizedError {
    var title: String { get }
    var description: String { get }
}
