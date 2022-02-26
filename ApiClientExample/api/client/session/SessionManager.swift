import Foundation
import Alamofire

class SessionManager {
    
    static let basicAuthSession = Alamofire.Session(
        configuration: URLSessionConfiguration.default,
        interceptor: BasicRequestInterceptor.shared,
        eventMonitors: [AlamofireLogger()]
    )
    
    static let bearerAuthSession = Alamofire.Session(
        configuration: URLSessionConfiguration.default,
        interceptor: OAuthRequestInterceptor.shared,
        eventMonitors: [AlamofireLogger()]
    )
    
    static let noneAuthSession = Alamofire.Session(
        configuration: URLSessionConfiguration.default,
        eventMonitors: [AlamofireLogger()]
    )
    
    static func session(authType: AuthType) -> Alamofire.Session {
        switch authType {
        case .basic: return self.basicAuthSession
        case .bearer: return self.bearerAuthSession
        case .none: return self.noneAuthSession
        }
    }
}
