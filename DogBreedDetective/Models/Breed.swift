import Foundation

struct Breed {
    let name: String        // "retriever-golden"
    let displayName: String // "Retriever (Golden)"
    let imageURL: String?   // Cached image URL
    
    init(name: String, imageURL: String? = nil) {
        self.name = name
        self.displayName = BreedFormatter.displayName(for: name)
        self.imageURL = imageURL
    }
}
