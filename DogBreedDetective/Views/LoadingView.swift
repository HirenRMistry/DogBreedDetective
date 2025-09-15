import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(2)
            Text("Loading questions...")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}
