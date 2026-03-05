// Content View - Root View
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var selectedScene: Scene?
    @State private var showTimer = false

    enum Tab {
        case home
        case calendar
        case achievement
        case settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedScene: $selectedScene, showTimer: $showTimer)
                .tabItem {
                    Label("专注", systemImage: "timer")
                }
                .tag(Tab.home)

            CalendarView()
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }
                .tag(Tab.calendar)

            AchievementView()
                .tabItem {
                    Label("成就", systemImage: "star.fill")
                }
                .tag(Tab.achievement)

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .tint(Color(hex: "5B8FB9"))
        .fullScreenCover(isPresented: $showTimer) {
            if let scene = selectedScene {
                FocusTimerView(scene: scene, isPresented: $showTimer)
            }
        }
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
