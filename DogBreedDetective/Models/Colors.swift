import SwiftUI

struct Colors {
    // Dog coat colors
    static let goldenRetriever = Color(red: 0.85, green: 0.65, blue: 0.13) // Golden yellow
    static let chocolateLab = Color(red: 0.48, green: 0.25, blue: 0.09) // Rich brown
    static let huskyBlue = Color(red: 0.53, green: 0.81, blue: 0.92) // Light blue
    static let beagleTricolor = Color(red: 0.65, green: 0.42, blue: 0.24) // Warm tan
    static let corgiOrange = Color(red: 0.96, green: 0.64, blue: 0.38) // Corgi orange
    static let poodleApricot = Color(red: 0.98, green: 0.84, blue: 0.65) // Soft apricot
    
    // Background gradients
    static let warmBackground = LinearGradient(
        colors: [poodleApricot.opacity(0.3), goldenRetriever.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let coolBackground = LinearGradient(
        colors: [huskyBlue.opacity(0.2), Color.blue.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successBackground = LinearGradient(
        colors: [goldenRetriever.opacity(0.15)],
        startPoint: .top,
        endPoint: .bottom
    )
}
