import SwiftUI

struct CelebrationView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Text("🎉")
                    .font(.largeTitle)
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -300...300) : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.0).delay(Double(index) * 0.1),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
