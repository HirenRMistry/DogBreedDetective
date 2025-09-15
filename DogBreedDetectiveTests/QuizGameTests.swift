import XCTest
@testable import DogBreedDetective

@MainActor
final class QuizGameTests: XCTestCase {
    
    var mockAPI: MockDogAPI!
    var game: QuizGame!
    
    override func setUp() {
        mockAPI = MockDogAPI()
        game = QuizGame(apiService: mockAPI)
    }
    
    func testQuizGameInitialState() {
        XCTAssertNil(game.currentQuestion)
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.totalQuestions, 0)
        XCTAssertFalse(game.isLoading)
        XCTAssertFalse(game.showResult)
        XCTAssertFalse(game.lastAnswerCorrect)
        XCTAssertNil(game.errorMessage)
        XCTAssertNil(game.selectedAnswer)
        XCTAssertNil(game.gameMode)
        XCTAssertEqual(game.questionsRemaining, 0)
    }
    
    func testScoreCalculation() {
        // Test initial percentage
        XCTAssertEqual(game.scorePercentage, 0)
        
        // Simulate correct answer
        game.score = 1
        game.totalQuestions = 1
        XCTAssertEqual(game.scorePercentage, 100)
        
        // Simulate mixed results
        game.score = 3
        game.totalQuestions = 4
        XCTAssertEqual(game.scorePercentage, 75)
        
        // Test edge case with zero division
        game.score = 0
        game.totalQuestions = 0
        XCTAssertEqual(game.scorePercentage, 0)
    }
    
    func testSubmitCorrectAnswer() {
        game.gameMode = .quick
        let correctBreed = Breed(name: "labrador")
        let question = Question(
            imageURL: "test-url",
            correctBreed: correctBreed,
            options: [correctBreed, Breed(name: "poodle"), Breed(name: "bulldog"), Breed(name: "beagle")]
        )
        game.currentQuestion = question
        
        game.submitAnswer(correctBreed)
        
        XCTAssertEqual(game.score, 1)
        XCTAssertEqual(game.totalQuestions, 1)
        XCTAssertTrue(game.lastAnswerCorrect)
        XCTAssertTrue(game.showResult)
        XCTAssertEqual(game.selectedAnswer, "labrador")
        XCTAssertEqual(game.toastMessage, "Correct! 🎉")
    }
    
    func testSubmitIncorrectAnswer() {
        game.gameMode = .quick
        let correctBreed = Breed(name: "labrador")
        let wrongBreed = Breed(name: "poodle")
        let question = Question(
            imageURL: "test-url",
            correctBreed: correctBreed,
            options: [correctBreed, wrongBreed, Breed(name: "bulldog"), Breed(name: "beagle")]
        )
        game.currentQuestion = question
        
        game.submitAnswer(wrongBreed)
        
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.totalQuestions, 1)
        XCTAssertFalse(game.lastAnswerCorrect)
        XCTAssertTrue(game.showResult)
        XCTAssertEqual(game.selectedAnswer, "poodle")
        XCTAssertEqual(game.toastMessage, "Incorrect. Answer: Labrador")
    }
    
    func testSubmitIncorrectAnswerWithHyphenatedBreed() {
        game.gameMode = .quick
        let correctBreed = Breed(name: "retriever-golden")
        let wrongBreed = Breed(name: "labrador")
        let question = Question(
            imageURL: "test-url",
            correctBreed: correctBreed,
            options: [correctBreed, wrongBreed, Breed(name: "poodle"), Breed(name: "bulldog")]
        )
        game.currentQuestion = question
        
        game.submitAnswer(wrongBreed)
        
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.totalQuestions, 1)
        XCTAssertFalse(game.lastAnswerCorrect)
        XCTAssertTrue(game.showResult)
        XCTAssertEqual(game.selectedAnswer, "labrador")
        XCTAssertEqual(game.toastMessage, "Incorrect. Answer: Retriever (Golden)")
    }
    
    func testSubmitAnswerWithNoCurrentQuestion() {
        XCTAssertNil(game.currentQuestion)
        
        game.submitAnswer(Breed(name: "labrador"))
        
        // Should not change any state when no current question
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.totalQuestions, 0)
        XCTAssertFalse(game.showResult)
    }
    
    func testIsGameFinished() {
        // No game mode set
        XCTAssertFalse(game.isGameFinished)
        
        // Quick mode, not finished
        game.gameMode = .quick
        game.totalQuestions = 5
        XCTAssertFalse(game.isGameFinished)
        
        // Quick mode, finished
        game.totalQuestions = 10
        XCTAssertTrue(game.isGameFinished)
        
        // Standard mode, finished
        game.gameMode = .standard
        game.totalQuestions = 30
        XCTAssertTrue(game.isGameFinished)
    }
    
    func testResetGame() {
        // Set some state
        game.score = 5
        game.totalQuestions = 8
        game.gameMode = .quick
        game.selectedAnswer = "test"
        game.showResult = true
        
        game.resetGame()
        
        // Verify everything is reset
        XCTAssertNil(game.currentQuestion)
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.totalQuestions, 0)
        XCTAssertNil(game.selectedAnswer)
        XCTAssertFalse(game.showResult)
        XCTAssertNil(game.gameMode)
        XCTAssertEqual(game.questionsRemaining, 0)
    }
    
    func testStartGameSuccess() async {
        await game.startGame(mode: .quick)
        
        XCTAssertEqual(game.gameMode, .quick)
        XCTAssertEqual(game.questionsRemaining, 10)
        XCTAssertFalse(game.isLoading)
        XCTAssertNil(game.errorMessage)
    }
    
    func testStartGameFailure() async {
        mockAPI.shouldFail = true
        
        await game.startGame(mode: .quick)
        
        XCTAssertFalse(game.isLoading)
        XCTAssertNotNil(game.errorMessage)
        XCTAssertEqual(game.errorMessage, "Failed to load game. Please check your internet connection.")
    }
}
