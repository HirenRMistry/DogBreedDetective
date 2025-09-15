import SwiftUI

struct AnswerButtonStyle: ButtonStyle {
    let option: String
    let selectedAnswer: String?
    let correctAnswer: String
    let showResult: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .foregroundColor(textColor)
            .scaleEffect(configuration.isPressed ? 0.95 : scale)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: showResult)
    }
    
    private var backgroundColor: Color {
        if showResult {
            if option == correctAnswer {
                return .green.opacity(0.8)
            } else if option == selectedAnswer {
                return .red.opacity(0.8)
            }
        }
        return Color.blue.opacity(0.1)
    }
    
    private var textColor: Color {
        if showResult && (option == correctAnswer || option == selectedAnswer) {
            return .white
        }
        return .primary
    }
    
    private var scale: CGFloat {
        if showResult && option == correctAnswer {
            return 1.05
        }
        return 1.0
    }
}
