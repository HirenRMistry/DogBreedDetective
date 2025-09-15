import Foundation

@MainActor
class QuizGame: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var score = 0
    @Published var totalQuestions = 0
    @Published var isLoading = false
    @Published var showResult = false
    @Published var lastAnswerCorrect = false
    @Published var errorMessage: String?
    @Published var selectedAnswer: String?
    @Published var toastMessage: String?
    @Published var showToast = false
    @Published var gameMode: GameMode?
    @Published var questionsRemaining = 0
    
    private let apiService: DogAPIProtocol
    private var cachedBreeds: [Breed] = []
    private var preloadedQuestions: [Breed] = []
    private var currentQuestionIndex = 0
    
    init(apiService: DogAPIProtocol = DogAPIService()) {
        self.apiService = apiService
    }
    
    func startGame(mode: GameMode) async {
        gameMode = mode
        questionsRemaining = mode.questionCount
        currentQuestionIndex = 0
        isLoading = true
        errorMessage = nil
        selectedAnswer = nil
        score = 0
        totalQuestions = 0
        
        do {
            if cachedBreeds.isEmpty {
                let breedNames = try await apiService.fetchAllBreeds()
                cachedBreeds = breedNames.map { Breed(name: $0) }
            }
            await preloadQuestions(count: mode.questionCount)
            await generateQuestion()
        } catch {
            errorMessage = "Failed to load game. Please check your internet connection."
        }
        isLoading = false
    }
    
    /// Preloads all questions concurrently to eliminate loading delays during gameplay
    /// Uses TaskGroup for parallel API calls - reduces 10-30s sequential loading to 2-3s
    private func preloadQuestions(count: Int) async {
        preloadedQuestions = []
        let selectedBreeds = cachedBreeds.shuffled().prefix(count)
        
        await withTaskGroup(of: Breed?.self) { group in
            for breed in selectedBreeds {
                group.addTask {
                    if breed.imageURL != nil {
                        print("found cached image woohooo")
                        return breed
                    }
                    do {
                        let imageURL = try await self.apiService.fetchRandomDogImage(breed: breed.name)
                        return Breed(name: breed.name, imageURL: imageURL)
                    } catch {
                        return nil
                    }
                }
            }
            
            for await breed in group {
                if let breed = breed {
                    preloadedQuestions.append(breed)
                    // Update cache
                    if let index = cachedBreeds.firstIndex(where: { $0.name == breed.name }) {
                        cachedBreeds[index] = breed
                        print("updating cache breed")
                    }
                }
            }
        }
        
        preloadedQuestions.shuffle()
    }
    
    func generateQuestion() async {
        guard currentQuestionIndex < preloadedQuestions.count,
              cachedBreeds.count >= 4 else {
            if currentQuestionIndex >= preloadedQuestions.count {
                // Game finished
                gameMode = nil
                currentQuestion = nil
                return
            }
            errorMessage = "Not enough breeds available for quiz."
            return
        }
        
        selectedAnswer = nil
        let correctBreed = preloadedQuestions[currentQuestionIndex]
                
        let wrongOptions = cachedBreeds.filter { $0.name != correctBreed.name }.shuffled().prefix(3)
        let options = ([correctBreed] + wrongOptions).shuffled()
        
        currentQuestion = Question(
            imageURL: correctBreed.imageURL!,
            correctBreed: correctBreed,
            options: Array(options)
        )
        
        currentQuestionIndex += 1
        questionsRemaining = (gameMode?.questionCount ?? 0) - totalQuestions
    }
    
    func submitAnswer(_ selectedBreed: Breed) {
        guard let question = currentQuestion else { return }
        
        selectedAnswer = selectedBreed.name
        totalQuestions += 1
        lastAnswerCorrect = selectedBreed.name == question.correctBreed.name
        
        if lastAnswerCorrect {
            score += 1
            toastMessage = "Correct! 🎉"
        } else {
            toastMessage = "Incorrect. Answer: \(question.correctBreed.displayName)"
        }
        
        showToast = true
        showResult = true
        
        // Check if game is finished
        if totalQuestions >= (gameMode?.questionCount ?? 0) {
            // Final question - delay before showing results screen
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                showResult = false
                showToast = false
            }
        } else {
            // Auto-advance to next question after 1 second for optimal pacing
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await nextQuestion()
            }
        }
    }
    
    func nextQuestion() async {
        showResult = false
        showToast = false
        await generateQuestion()
    }
    
    func finishGame() async {
        showResult = false
        showToast = false
        gameMode = nil
        currentQuestion = nil
        // Keep score visible for final results
    }
    
    func resetGame() {
        currentQuestion = nil
        score = 0
        totalQuestions = 0
        selectedAnswer = nil
        showResult = false
        showToast = false
        errorMessage = nil
        gameMode = nil
        questionsRemaining = 0
        preloadedQuestions = []
        currentQuestionIndex = 0
    }
    
    var scorePercentage: Int {
        totalQuestions > 0 ? Int((Double(score) / Double(totalQuestions)) * 100) : 0
    }
    
    var isGameFinished: Bool {
        gameMode != nil && totalQuestions >= (gameMode?.questionCount ?? 0)
    }
}
