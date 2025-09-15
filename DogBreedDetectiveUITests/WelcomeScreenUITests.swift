import XCTest

final class WelcomeScreenUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testWelcomeScreenElements() throws {
        XCTAssertTrue(app.staticTexts["Dog Breed Detective"].exists)
        XCTAssertTrue(app.staticTexts["Test your knowledge of dog breeds!"].exists)
        XCTAssertTrue(app.buttons["Quick Fire (10 questions)"].exists)
        XCTAssertTrue(app.buttons["Standard (30 questions)"].exists)
    }
    
    func testGameModeSelection() throws {
        let quickFireButton = app.buttons["Quick Fire (10 questions)"]
        let standardButton = app.buttons["Standard (30 questions)"]
        
        XCTAssertTrue(quickFireButton.exists)
        XCTAssertTrue(quickFireButton.isEnabled)
        XCTAssertTrue(standardButton.exists)
        XCTAssertTrue(standardButton.isEnabled)
        
        // Test quick fire selection
        quickFireButton.tap()
        let loadingOrQuestion = app.staticTexts["Loading questions..."].exists || 
                               app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 10)
        XCTAssertTrue(loadingOrQuestion)
        
        // Go back and test standard selection
        if app.buttons["Home"].exists {
            app.buttons["Home"].tap()
            XCTAssertTrue(app.staticTexts["Dog Breed Detective"].waitForExistence(timeout: 5))
            
            standardButton.tap()
            let standardLoadingOrQuestion = app.staticTexts["Loading questions..."].exists || 
                                          app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 15)
            XCTAssertTrue(standardLoadingOrQuestion)
        }
    }
}
