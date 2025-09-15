import SwiftUI

struct QuizView: View {
    let question: Question
    @ObservedObject var game: QuizGame
    
    var body: some View {
        VStack(spacing: 25) {
            AsyncImageView(url: question.imageURL)
            
            Text("What breed is this dog?")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                ForEach(question.options, id: \.name) { option in
                    Button(option.displayName) {
                        game.submitAnswer(option)
                    }
                    .multilineTextAlignment(.center)
                    .buttonStyle(AnswerButtonStyle(
                        option: option.name,
                        selectedAnswer: game.selectedAnswer,
                        correctAnswer: question.correctBreed.name,
                        showResult: game.showResult
                    ))
                    .disabled(game.showResult)
                }
            }
        }
    }
}
