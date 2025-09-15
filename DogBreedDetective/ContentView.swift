//
//  ContentView.swift
//  DogBreedDetective
//
//  Created by Hiren Mistry on 09/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = QuizGame()
    
    private var backgroundForCurrentScreen: LinearGradient {
        if (game.currentQuestion == nil && !game.isLoading && game.errorMessage == nil) || game.isGameFinished {
            // Welcome or Final Results screen
            return Colors.warmBackground
        } else {
            // Quiz, Loading, or Error screen
            return Colors.coolBackground
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main content
            VStack(spacing: 20) {
                if let errorMessage = game.errorMessage {
                    ErrorView(message: errorMessage, game: game)
                } else if game.isLoading {
                    LoadingView()
                } else if game.isGameFinished {
                    FinalResultsView(game: game)
                } else if let question = game.currentQuestion {
                    QuizView(question: question, game: game)
                } else {
                    WelcomeView(game: game)
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Navigation
            if game.currentQuestion != nil || game.isGameFinished {
                BottomNavBar(game: game)
            }
        }
        .background(
            game.showResult && game.lastAnswerCorrect ? 
            Colors.successBackground : 
            backgroundForCurrentScreen
        )
        .animation(.easeInOut(duration: 0.3), value: game.showResult && game.lastAnswerCorrect)
        .navigationTitle("Dog Breed Detective")
        .navigationBarTitleDisplayMode(.large)
        .overlay(alignment: .top) {
            if game.showToast, let message = game.toastMessage {
                ToastView(message: message, isCorrect: game.lastAnswerCorrect)
                    .padding(.top, 10)
            }
        }
        .overlay {
            if game.showResult && game.lastAnswerCorrect {
                CelebrationView()
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
