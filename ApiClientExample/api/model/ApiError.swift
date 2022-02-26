import Foundation
import Alamofire

struct ApiErrorResponse: Decodable {
    var code: String?
    var message: String?
}

class ApiError: Error {
    var status: Int?
    var response: ApiErrorResponse?
    
    init(status: Int? = nil, response: ApiErrorResponse? = nil) {
        self.status = status
        self.response = response
    }
}

extension Error {
    
    var asApiError: ApiError? {
        self as? ApiError
    }
}

extension AFDataResponse {
    
    func asApiError() -> ApiError {
        if let data = data {
            if let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                return ApiError(status: self.response?.statusCode, response: errorResponse)
            }
        }
        return ApiError(status: self.response?.statusCode, response: nil)
    }
}
