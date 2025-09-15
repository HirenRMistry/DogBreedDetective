import Foundation

struct DogAPIResponse: Codable {
    let message: String
    let status: String
}

struct BreedsResponse: Codable {
    let message: [String: [String]]
    let status: String
}
