import Foundation

struct UserAccessToken: AccessToken, Decodable {
    var type: String
    var accessToken: String
    var refreshToken: String
    var expiresIn: Int64
    var scope: String

    enum CodingKeys: String, CodingKey {
        case type = "token_type"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope = "scope"
    }
}
