import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

enum AppConstants {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    enum Radius {
        static let card: CGFloat = 24
        static let button: CGFloat = 16
        static let chip: CGFloat = 12
    }
    enum CardHeight {
        static let featured: CGFloat = 220
        static let unlocked: CGFloat = 160
        static let locked: CGFloat = 140
    }
    enum Encouragements {
        static let messages: [String] = [
            "专注是最好的礼物 🌟",
            "你做到了！继续保持 ✨",
            "每一次专注都让你更强大 💪",
            "今天又进步了一点点 🌱",
            "专注的力量，改变你的生活 🦋"
        ]
    }
}
