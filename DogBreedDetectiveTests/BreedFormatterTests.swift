import XCTest
@testable import DogBreedDetective

final class BreedFormatterTests: XCTestCase {
    
    func testSimpleBreedFormatting() {
        XCTAssertEqual(BreedFormatter.displayName(for: "labrador"), "Labrador")
        XCTAssertEqual(BreedFormatter.displayName(for: "poodle"), "Poodle")
    }
    
    func testHyphenatedBreedFormatting() {
        XCTAssertEqual(BreedFormatter.displayName(for: "terrier-russell"), "Terrier (Russell)")
        XCTAssertEqual(BreedFormatter.displayName(for: "retriever-golden"), "Retriever (Golden)")
    }
    
    func testMultipleHyphenatedBreedFormatting() {
        XCTAssertEqual(BreedFormatter.displayName(for: "hound-afghan-special"), "Hound (Afghan Special)")
        XCTAssertEqual(BreedFormatter.displayName(for: "terrier-bull-staffordshire"), "Terrier (Bull Staffordshire)")
    }
}
