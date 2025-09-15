import XCTest

final class GameplayUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testQuickFireGameStart() throws {
        app.buttons["Quick Fire (10 questions)"].tap()
        
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertTrue(loadingText.waitForNonExistence(timeout: 10))
        }
        
        let questionText = app.staticTexts["What breed is this dog?"]
        XCTAssertTrue(questionText.waitForExistence(timeout: 10))
        
        XCTAssertTrue(app.staticTexts["Score: 0/10"].exists)
        XCTAssertTrue(app.staticTexts["10 left"].exists)
        XCTAssertTrue(app.buttons["Home"].exists)
    }
    
    func testStandardGameStart() throws {
        app.buttons["Standard (30 questions)"].tap()
        
        let loadingText = app.staticTexts["Loading questions..."]
        if loadingText.exists {
            XCTAssertTrue(loadingText.waitForNonExistence(timeout: 15))
        }
        
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Score: 0/30"].exists)
        XCTAssertTrue(app.staticTexts["30 left"].exists)
    }
    
    func testAnswerSelection() throws {
        app.buttons["Quick Fire (10 questions)"].tap()
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 10))
        
        let buttons = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'answer' OR label != 'Home'"))
        if buttons.count > 0 {
            let firstAnswerButton = buttons.element(boundBy: 0)
            if firstAnswerButton.exists && firstAnswerButton.isEnabled {
                firstAnswerButton.tap()
                
                let scoreUpdated = app.staticTexts["Score: 1/10"].exists || app.staticTexts["Score: 0/10"].exists
                XCTAssertTrue(scoreUpdated)
                
                XCTAssertTrue(app.staticTexts["9 left"].waitForExistence(timeout: 3))
            }
        }
    }
    
    func testCompleteQuickFireGame() throws {
        try completeGameTest(buttonText: "Quick Fire (10 questions)", totalQuestions: 10)
    }
    
    func testCompleteStandardGame() throws {
        try completeGameTest(buttonText: "Standard (30 questions)", totalQuestions: 30)
    }
    
    private func completeGameTest(buttonText: String, totalQuestions: Int) throws {
        app.buttons[buttonText].tap()
        
        // Wait for first question to load
        XCTAssertTrue(app.staticTexts["What breed is this dog?"].waitForExistence(timeout: 15))
        
        // Answer all questions
        for questionNumber in 1...totalQuestions {
            // Find and tap any answer button
            let buttons = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'answer' OR label != 'Home'"))
            if buttons.count > 0 {
                let firstAnswerButton = buttons.element(boundBy: 0)
                if firstAnswerButton.exists && firstAnswerButton.isEnabled {
                    firstAnswerButton.tap()
                    
                    // Wait for answer processing
                    sleep(2)
                    
                    // Check progress only for non-final questions
                    if questionNumber < totalQuestions {
                        let questionsLeft = totalQuestions - questionNumber
                        XCTAssertTrue(app.staticTexts["\(questionsLeft) left"].exists)
                    }
                }
            }
        }
        
        // After completing all questions, verify results screen
        XCTAssertTrue(app.staticTexts["Final Score"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Play Again"].exists)
        XCTAssertTrue(app.buttons["Home"].exists)
    }
}
