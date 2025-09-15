import SwiftUI

struct ErrorView: View {
    let message: String
    let game: QuizGame
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(message)
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                game.resetGame()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}
