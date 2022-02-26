import Foundation
import Alamofire

typealias Parameters = [String: Any]

enum AuthType {
    case basic, bearer, none
}

enum Method {
    case get, post, put, patch, delete
}

final class Endpoint<Response> {
    let authType: AuthType
    let method: Method
    let path: String
    let parameters: Parameters?
    let encoding: ParameterEncoding
    let decode: (Data) throws -> Response

    init(
        authType: AuthType = .none,
        method: Method = .get,
        path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        decode: @escaping (Data) throws -> Response
    ) {
        self.authType = authType
        self.method = method
        self.path = path
        self.parameters = parameters
        self.encoding = encoding
        self.decode = decode
    }
}

extension Endpoint where Response: Swift.Decodable {
    convenience init(
        authType: AuthType = .none,
        method: Method = .get,
        path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) {
        self.init(
            authType: authType,
            method: method,
            path: path,
            parameters: parameters,
            encoding: encoding
        ) {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(.apiDateFormatter)
            return try jsonDecoder.decode(Response.self, from: $0)
        }
    }
}

extension Endpoint where Response == Void {
    convenience init(
        authType: AuthType = .none,
        method: Method = .get,
        path: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) {
        self.init(
            authType: authType,
            method: method,
            path: path,
            parameters: parameters,
            encoding: encoding,
            decode: { _ in () }
        )
    }
}

extension DateFormatter {
    static var apiDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = Api.DATE_TIME_WITH_ZONE
        return formatter
    }
}
