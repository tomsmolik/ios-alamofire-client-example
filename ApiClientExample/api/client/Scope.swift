import Foundation
import RxSwift

struct Scope {
    enum Guest {}
    enum User {}
    enum Admin {}
}

struct AuthorizedEndpoint<Authorization, Response> {
    fileprivate let raw: Endpoint<Response>
    init(raw: Endpoint<Response>) { self.raw = raw }
}

struct AuthorizedClient<Authorization> {
    fileprivate let raw: ClientProtocol
    init(raw: ClientProtocol = Client.shared) { self.raw = raw }
}

extension AuthorizedClient where Authorization == Scope.Guest {
    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Guest, Response>) -> Single<Response> {
        return raw.request(endpoint.raw)
    }
}

extension AuthorizedClient where Authorization == Scope.User {
    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Guest, Response>) -> Single<Response> {
        return raw.request(endpoint.raw)
    }

    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.User, Response>) -> Single<Response> {
        return raw.request(endpoint.raw)
    }
}

extension AuthorizedClient where Authorization == Scope.Admin {
    func request<Response>(_ endpoint: AuthorizedEndpoint<Scope.Admin, Response>) -> Single<Response> {
        return raw.request(endpoint.raw)
    }
}
