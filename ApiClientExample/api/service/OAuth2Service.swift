import Foundation
import Alamofire

enum GrantType: CustomStringConvertible {
    case password
    case refreshToken
    case clientCredentials
    
    var description: String {
        switch self {
        case .password: return "password"
        case .refreshToken: return "refresh_token"
        case .clientCredentials: return "client_credentials"
        }
    }
}

extension Api {
    
    enum OAuth2Service {
        
        static func getClientAccessToken() -> AuthorizedEndpoint<Scope.Guest, ClientAccessToken> {
            return AuthorizedEndpoint(
                raw: Endpoint(
                    authType: .basic,
                    method: .post,
                    path: "oauth/token",
                    parameters: [
                        "grant_type": GrantType.clientCredentials
                    ]
                )
            )
        }
        
        static func getUserAccessToken(username: String, password: String) -> AuthorizedEndpoint<Scope.Guest, UserAccessToken> {
            return AuthorizedEndpoint(
                raw: Endpoint(
                    authType: .basic,
                    method: .post,
                    path: "oauth/token",
                    parameters: [
                        "username": username,
                        "password": password,
                        "grant_type": GrantType.password
                    ]
                )
            )
        }
        
        static func refreshUserAccessToken(refreshToken: String) -> AuthorizedEndpoint<Scope.Guest, UserAccessToken> {
            return AuthorizedEndpoint(
                raw: Endpoint(
                    authType: .basic,
                    method: .post,
                    path: "oauth/token",
                    parameters: [
                        "refresh_token": refreshToken,
                        "grant_type": GrantType.refreshToken
                    ]
                )
            )
        }
    }
}
