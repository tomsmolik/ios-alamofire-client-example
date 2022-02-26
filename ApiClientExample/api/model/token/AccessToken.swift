import Foundation

protocol AccessToken {
    var type: String { get set }
    var accessToken: String { get set }
    var expiresIn: Int64 { get set }
    var scope: String { get set }
}
