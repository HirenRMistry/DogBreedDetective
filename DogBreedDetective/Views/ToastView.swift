import SwiftUI

struct ToastView: View {
    let message: String
    let isCorrect: Bool
    
    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isCorrect ? .green : .red)
            )
            .scaleEffect(isCorrect ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isCorrect)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}
