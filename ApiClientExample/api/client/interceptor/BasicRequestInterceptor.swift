import Foundation
import Alamofire

class BasicRequestInterceptor: RequestInterceptor {
    
    static let shared = BasicRequestInterceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        let authorization = basicCredentials(username: Api.CLIENT_ID, password: Api.CLIENT_SECRET)
        adaptedRequest.setValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
        completion(.success(adaptedRequest))
    }
    
    private func basicCredentials(username: String, password: String) -> String {
        return String(format: "%@:%@", username, password)
            .data(using: String.Encoding.utf8)!
            .base64EncodedString()
    }
}
