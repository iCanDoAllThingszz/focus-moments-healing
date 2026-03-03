// FocusMoments App Entry Point
import SwiftUI

@main
struct FocusMomentsApp: App {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var sceneViewModel = SceneViewModel()
    @StateObject private var timerViewModel = TimerViewModel()
    @StateObject private var statsViewModel = StatsViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(sceneViewModel)
                .environmentObject(timerViewModel)
                .environmentObject(statsViewModel)
        }
    }
}
