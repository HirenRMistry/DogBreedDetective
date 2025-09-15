import Foundation

struct BreedFormatter {
    /// Converts API breed format to user-friendly display format
    /// "terrier-russell" -> "Terrier (Russell)"
    /// "hound-afghan-special" -> "Hound (Afghan Special)"
    /// "labrador" -> "Labrador"
    static func displayName(for breed: String) -> String {
        if breed.contains("-") {
            let parts = breed.split(separator: "-").map { String($0).capitalized }
            if parts.count >= 2 {
                let mainBreed = parts[0]
                let subBreeds = parts[1...].joined(separator: " ")
                return "\(mainBreed) (\(subBreeds))"
            }
        }
        return breed.capitalized
    }
}
