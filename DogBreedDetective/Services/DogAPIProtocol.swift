import Foundation

protocol DogAPIProtocol {
    func fetchRandomDogImage(breed: String) async throws -> String
    func fetchAllBreeds() async throws -> [String]
}
