import Foundation

class UserProperties {
    
    static let defaults = UserDefaults.standard
    
    static let ACCESS_TOKEN_KEY = "accessToken"
    static let REFRESH_TOKEN_KEY = "refreshToken"
    
    static func setAccessToken(accessToken: UserAccessToken) {
        defaults.set(accessToken.accessToken, forKey: ACCESS_TOKEN_KEY)
        defaults.set(accessToken.refreshToken, forKey: REFRESH_TOKEN_KEY)
    }
    
    static func getAccessToken() -> String? {
        return defaults.string(forKey: ACCESS_TOKEN_KEY)
    }
    
    static func getRefreshToken() -> String? {
        return defaults.string(forKey: REFRESH_TOKEN_KEY)
    }
}
