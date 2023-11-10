import Foundation

extension Bundle {
    static func getFromPlist(key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }
}
