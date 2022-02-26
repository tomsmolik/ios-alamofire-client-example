import Foundation
import RxSwift

final class LoginViewModel: NSObject, ObservableObject {
    
    let client = AuthorizedClient<Scope.Guest>()
    let disposeBag = DisposeBag()
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var isLoading = false
    
    @Published var alert = false
    @Published var alertMsg = ""
    
    func authenticate() {
        if !username.isEmpty {
            if !password.isEmpty {
                authenticate(username: username, password: password)
            }
        }
    }
        
    fileprivate func authenticate(username: String, password: String) {
        self.isLoading = true
        
        client
            .request(Api.OAuth2Service.getUserAccessToken(username: username, password: password))
            .asObservable()
            .subscribe(
                onNext: { accessToken in
                    DispatchQueue.main.async {
                        // Store access token
                        UserProperties.setAccessToken(accessToken: accessToken)
               
                        self.isLoading = false
                        self.alertMsg = "Login successful"
                        self.alert.toggle()
                    }
                },
                onError: { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        // Hendle api error
                        guard let errorMessage = error.asApiError?.response?.message else {
                            self.alertMsg = "Unexpected error."
                            self.alert.toggle()
                            return
                        }
                        self.alertMsg = errorMessage
                        self.alert.toggle()
                    }
                }
            )
            .disposed(by: disposeBag)
    }
}
