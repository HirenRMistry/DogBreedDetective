import Foundation
@testable import DogBreedDetective

class MockDogAPI: DogAPIProtocol {
    var shouldFail = false
    var mockBreeds = ["labrador", "poodle", "retriever-golden", "retriever-chesapeake"]
    var mockImageURL = "https://test.com/dog.jpg"
    
    func fetchAllBreeds() async throws -> [String] {
        if shouldFail {
            throw NSError(domain: "TestError", code: 1)
        }
        return mockBreeds
    }
    
    func fetchRandomDogImage(breed: String) async throws -> String {
        if shouldFail {
            throw NSError(domain: "TestError", code: 1)
        }
        return mockImageURL
    }
}
