import XCTest
@testable import DogBreedDetective

final class ModelsTests: XCTestCase {
    
    func testDogAPIResponseDecoding() throws {
        let json = """
        {
            "message": "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg",
            "status": "success"
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(DogAPIResponse.self, from: data)
        
        XCTAssertEqual(response.message, "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg")
        XCTAssertEqual(response.status, "success")
    }
    
    func testBreedsResponseDecoding() throws {
        let json = """
        {
            "message": {
                "affenpinscher": [],
                "retriever": ["golden", "chesapeake"],
                "rajapalayam": ["indian"]
            },
            "status": "success"
        }
        """
        
        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(BreedsResponse.self, from: data)
        
        XCTAssertEqual(response.message.keys.count, 3)
        XCTAssertTrue(response.message.keys.contains("retriever"))
        XCTAssertEqual(response.message["retriever"], ["golden", "chesapeake"])
        XCTAssertEqual(response.status, "success")
    }
}
