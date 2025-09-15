import SwiftUI

struct BottomNavBar: View {
    @ObservedObject var game: QuizGame
    
    var body: some View {
        HStack {
            Button("Home") {
                game.resetGame()
            }
            .foregroundColor(Colors.huskyBlue)
            
            Spacer()
            
            if !game.isGameFinished {
                VStack(spacing: 2) {
                    Text("Score: \(game.score)/\(game.gameMode?.questionCount ?? 0)")
                        .font(.headline)
                        .foregroundColor(Colors.chocolateLab)
                    Text("\(game.questionsRemaining) left")
                        .font(.caption)
                        .foregroundColor(Colors.beagleTricolor)
                }
            }
        }
        .padding()
        .background(.regularMaterial)
    }
}
