import Foundation

enum GameMode {
    case quick // 10 questions
    case standard // 30 questions
    
    var questionCount: Int {
        switch self {
        case .quick: return 10
        case .standard: return 30
        }
    }
    
    var title: String {
        switch self {
        case .quick: return "Quick Fire (10)"
        case .standard: return "Standard (30)"
        }
    }
}
