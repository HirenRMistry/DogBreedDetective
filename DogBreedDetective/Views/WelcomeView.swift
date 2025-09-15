import SwiftUI

struct WelcomeView: View {
    let game: QuizGame
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "pawprint.fill")
                .font(.system(size: 80))
                .foregroundColor(Colors.goldenRetriever)
            
            Text("Dog Breed Detective")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Colors.chocolateLab)
            
            Text("Test your knowledge of dog breeds!")
                .font(.title2)
                .foregroundColor(Colors.beagleTricolor)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Button("Quick Fire (10 questions)") {
                    Task { await game.startGame(mode: .quick) }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Colors.corgiOrange)
                
                Button("Standard (30 questions)") {
                    Task { await game.startGame(mode: .standard) }
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(Colors.huskyBlue)
            }
        }
    }
}
