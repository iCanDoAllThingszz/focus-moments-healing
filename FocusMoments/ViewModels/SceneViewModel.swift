// SceneViewModel - Scene Management
import Foundation
import Combine

class SceneViewModel: ObservableObject {
    @Published var scenes: [Scene] = []
    @Published var totalStars: Int = 0
    @Published var totalSessions: Int = 0

    private let preferences = UserPreferences.shared
    private let dataManager = DataManager.shared

    init() {
        loadScenes()
    }

    // MARK: - Load Scenes with unlock status
    func loadScenes() {
        totalSessions = dataManager.totalSessionCount
        totalStars = preferences.totalStars

        scenes = allScenes.map { scene in
            var mutableScene = scene
            mutableScene.isUnlocked = preferences.isSceneUnlocked(scene.name)
            return mutableScene
        }

        checkAndUnlockScenes()
    }

    // MARK: - Check and unlock scenes based on total sessions
    func checkAndUnlockScenes() {
        let total = dataManager.totalSessionCount
        var hasNewUnlock = false

        for scene in allScenes {
            if !preferences.isSceneUnlocked(scene.name) && total >= scene.unlockRequirement {
                preferences.unlockScene(scene.name)
                hasNewUnlock = true
            }
        }

        if hasNewUnlock {
            loadScenes()
        }
    }

    // MARK: - Get unlocked scenes
    var unlockedScenes: [Scene] {
        scenes.filter { $0.isUnlocked }
    }

    // MARK: - Get locked scenes
    var lockedScenes: [Scene] {
        scenes.filter { !$0.isUnlocked }
    }

    // MARK: - Get next unlock requirement
    var nextUnlockInfo: (name: String, requirement: Int, current: Int)? {
        let locked = lockedScenes
        guard let nextScene = locked.first else { return nil }
        return (nextScene.name, nextScene.unlockRequirement, totalSessions)
    }

    // MARK: - Refresh data
    func refresh() {
        loadScenes()
    }
}
