import Foundation
import Alamofire
import RxSwift

protocol ClientProtocol {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

final class Client: ClientProtocol {
    
    static let shared = Client()
    
    private var _manager: Alamofire.Session!
    private var manager: Alamofire.Session {
        return  _manager
    }
    
    private let queue = DispatchQueue(label: "request-queue")
    
    private init() {
        self._manager = SessionManager.session(authType: .none)
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        // Create session by endpoint
        self._manager = SessionManager.session(authType: endpoint.authType)
        
        return Single<Response>.create { observer in
            let request = self
                .manager
                .request(
                    self.url(path: endpoint.path),
                    method: self.httpMethod(from: endpoint.method),
                    parameters: endpoint.parameters,
                    encoding: endpoint.encoding
                )
                .validate()
                .validate(statusCode: 200..<300)
                .responseData(queue: self.queue) { response in
                    let data = response.tryMap(endpoint.decode)
                    switch data.result {
                    case let .success(val):
                        observer(.success(val))
                    case .failure:
                        observer(.failure(response.asApiError()))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension Client {
    
    private func url(path: String) -> URL {
        let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as! String
        return URL(string: baseUrl)!.appendingPathComponent(path)
    }
}

extension Client {
    
    private func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
        switch method {
        case .get: return .get
        case .post: return .post
        case .put: return .put
        case .patch: return .patch
        case .delete: return .delete
        }
    }
}
