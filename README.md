# Alamofire REST Client example

Example of simple OAuth2 authentication using Alamofire and RxSwift library.

**Supported grant types:**

- password
- refresh_token
- client_credentials

**Supported interceptors:**

- Client credentials grant type authentication interceptor
- Password grant type authentication and refresh token interceptor with request synchronization

# Example call

```swift

extension Api {
    
    enum OAuth2Service {
                
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
       ...
    }
}
```
```swift
 
 let client = AuthorizedClient<Scope.Guest>()
 
 client
    .request(Api.OAuth2Service.getUserAccessToken(username: username, password: password))
    .asObservable()
    .subscribe(
        onNext: { accessToken in
            DispatchQueue.main.async {
                // Store access token
            }
        },
        onError: { error in
            DispatchQueue.main.async {
                // Handle api error
                guard let errorResponse = error.asApiError?.response else {  
                    ...
                    return
                }
                ...
            }
        }
    )
    .disposed(by: disposeBag)
```
