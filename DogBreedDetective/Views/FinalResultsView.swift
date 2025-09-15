import SwiftUI

struct FinalResultsView: View {
    let game: QuizGame
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundColor(Colors.goldenRetriever)
            
            Text("Game Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Colors.chocolateLab)
            
            VStack(spacing: 10) {
                Text("Final Score")
                    .font(.title2)
                    .foregroundColor(Colors.beagleTricolor)
                
                Text("\(game.score)/\(game.totalQuestions)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Colors.huskyBlue)
                
                Text("\(game.scorePercentage)%")
                    .font(.title)
                    .foregroundColor(Colors.beagleTricolor)
            }
            
            Button("Play Again") {
                game.resetGame()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Colors.corgiOrange)
        }
    }
}
