import Foundation
import Alamofire
import RxSwift

class OAuthRequestInterceptor: RequestInterceptor {
    
    static let shared = OAuthRequestInterceptor()
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ userAccessToken: UserAccessToken?) -> Void
    
    private let lock = NSLock()
    private let disposeBag = DisposeBag()
    
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        if let accessToken = UserProperties.getAccessToken() {
            adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(adaptedRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock() ; defer { lock.unlock() }
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401,
              let url = request.request?.url?.absoluteString, !url.contains("/oauth/token") else {
                  // The request did not fail due to a 401 Unauthorized response.
                  // Return the original error and don't retry the request.
                  return completion(.doNotRetryWithError(error))
              }
        // Add to retry queue
        requestsToRetry.append(completion)
        
        if !isRefreshing {
            refreshToken { [weak self] succeeded, refreshedAccessToken in
                guard let strongSelf = self else { return }
                strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                
                if succeeded {
                    // Store access token
                    UserProperties.setAccessToken(accessToken: refreshedAccessToken!)
                    // Retry all requests in queue
                    strongSelf.requestsToRetry.forEach { $0(.retry) }
                    strongSelf.requestsToRetry.removeAll()
                } else {
                    // TODO delete stored access token and go to login view
                    completion(.doNotRetryWithError(error))
                }
            }
        }
    }
    
    private func refreshToken(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        guard let refreshToken = UserProperties.getRefreshToken() else {
            completion(false, nil)
            return
        }
        
        isRefreshing = true
        
        AuthorizedClient<Scope.Guest>(raw: Client.shared)
            .request(Api.OAuth2Service.refreshUserAccessToken(refreshToken: refreshToken))
            .asObservable()
            .subscribe(
                onNext: { refreshedAccessToken in
                    self.isRefreshing = false
                    completion(true, refreshedAccessToken)
                },
                onError: { _ in
                    self.isRefreshing = false
                    completion(false, nil)
                }
            )
            .disposed(by: disposeBag)
    }
}
