import Foundation

class DogAPIService: DogAPIProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://dog.ceo/api"
    
    /// Fetches a random image URL for the specified breed
    /// - Parameter breed: Dog breed name (e.g., "labrador" or "retriever-golden")
    /// - Returns: Image URL string from Dog CEO API
    func fetchRandomDogImage(breed: String) async throws -> String {
        let url: URL
        
        if breed.contains("-") {
            // Sub-breed format: "retriever-golden" -> /breed/retriever/golden/images/random
            let parts = breed.split(separator: "-")
            if parts.count == 2 {
                let mainBreed = String(parts[0])
                let subBreed = String(parts[1])
                url = URL(string: "\(baseURL)/breed/\(mainBreed)/\(subBreed)/images/random")!
            } else {
                throw NSError(domain: "InvalidBreedFormat", code: 1)
            }
        } else {
            // Main breed format: "labrador" -> /breed/labrador/images/random
            url = URL(string: "\(baseURL)/breed/\(breed)/images/random")!
        }
        
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(DogAPIResponse.self, from: data)
        return response.message
    }
    
    /// Fetches all available dog breeds from the API
    /// - Returns: Sorted array of breed names including sub-breeds (e.g., "retriever-golden")
    func fetchAllBreeds() async throws -> [String] {
        let url = URL(string: "\(baseURL)/breeds/list/all")!
        let (data, _) = try await session.data(from: url)
        let response = try JSONDecoder().decode(BreedsResponse.self, from: data)
        
        var allBreeds: [String] = []
        
        for (mainBreed, subBreeds) in response.message {
            if subBreeds.isEmpty {
                // No sub-breeds, use main breed
                allBreeds.append(mainBreed)
            } else {
                // Add all sub-breeds in format "mainbreed-subbreed"
                for subBreed in subBreeds {
                    allBreeds.append("\(mainBreed)-\(subBreed)")
                }
            }
        }
        
        return allBreeds.sorted()
    }
}
