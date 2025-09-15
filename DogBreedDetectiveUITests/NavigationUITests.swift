import XCTest

final class NavigationUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testHomeButtonDuringGame() throws {
        app.buttons["Quick Fire (10 questions)"].tap()
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 10))
        
        app.buttons["Home"].tap()
        XCTAssertTrue(app.staticTexts["Dog Breed Detective"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Quick Fire (10 questions)"].exists)
    }
    
    func testBackToWelcomeFromBothGameModes() throws {
        // Test from Quick Fire
        app.buttons["Quick Fire (10 questions)"].tap()
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 10))
        app.buttons["Home"].tap()
        XCTAssertTrue(app.staticTexts["Dog Breed Detective"].exists)
        
        // Test from Standard
        app.buttons["Standard (30 questions)"].tap()
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 15))
        app.buttons["Home"].tap()
        XCTAssertTrue(app.staticTexts["Dog Breed Detective"].exists)
    }
}
