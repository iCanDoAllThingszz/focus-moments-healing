import Foundation
import Observation

@Observable
final class HomeViewModel {
    private let dataManager = DataManager.shared

    var showUnlockPopup: Bool = false
    var pendingUnlockScene: Scene? = nil
    private var unlockQueue: [Scene] = []

    var unlockedScenes: [Scene] {
        Scene.all.filter { dataManager.unlockedSceneIds.contains($0.id) }
    }

    var lockedScenes: [Scene] {
        Scene.all.filter { !dataManager.unlockedSceneIds.contains($0.id) }
    }

    var featuredScene: Scene {
        unlockedScenes.last ?? Scene.all[0]
    }

    var totalStars: Int { dataManager.totalStars }
    var totalSessions: Int { dataManager.totalSessions }
    var todaySessions: Int { dataManager.todaySessions }
    var weekSessions: Int { dataManager.weekSessions }

    func handleSessionComplete() {
        let newScenes = dataManager.recordSession()
        unlockQueue = newScenes
        showNextUnlock()
    }

    func dismissUnlock() {
        showUnlockPopup = false
        pendingUnlockScene = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showNextUnlock()
        }
    }

    private func showNextUnlock() {
        guard !unlockQueue.isEmpty else { return }
        pendingUnlockScene = unlockQueue.removeFirst()
        showUnlockPopup = true
    }
}
