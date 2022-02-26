import Foundation
import Alamofire

class BasicRequestInterceptor: RequestInterceptor {
    
    static let shared = BasicRequestInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.setValue("Basic \(basicCredentials())", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
    }
    
    private func basicCredentials() -> String {
        let clientId = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_ID") as! String
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "API_CLIENT_SECRET") as! String
        
        return String(format: "%@:%@", clientId, clientSecret)
            .data(using: String.Encoding.utf8)!
            .base64EncodedString()
    }
}
