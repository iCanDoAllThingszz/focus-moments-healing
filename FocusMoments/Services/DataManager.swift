import Foundation
import Observation

@Observable
final class DataManager {
    static let shared = DataManager()

    private let defaults = UserDefaults.standard

    var totalStars: Int {
        get { defaults.integer(forKey: "totalStars") }
        set { defaults.set(newValue, forKey: "totalStars") }
    }

    var totalSessions: Int {
        get { defaults.integer(forKey: "totalSessions") }
        set { defaults.set(newValue, forKey: "totalSessions") }
    }

    var todaySessions: Int {
        get {
            resetIfNeeded()
            return defaults.integer(forKey: "todaySessions")
        }
        set { defaults.set(newValue, forKey: "todaySessions") }
    }

    var weekSessions: Int {
        get {
            resetIfNeeded()
            return defaults.integer(forKey: "weekSessions")
        }
        set { defaults.set(newValue, forKey: "weekSessions") }
    }

    var unlockedSceneIds: [String] {
        get { defaults.stringArray(forKey: "unlockedSceneIds") ?? ["tree", "cat", "fish"] }
        set { defaults.set(newValue, forKey: "unlockedSceneIds") }
    }

    private init() {
        // Initialize defaults
        if defaults.object(forKey: "unlockedSceneIds") == nil {
            defaults.set(["tree", "cat", "fish"], forKey: "unlockedSceneIds")
        }
    }

    private func resetIfNeeded() {
        let now = Date()
        let calendar = Calendar.current

        if let lastReset = defaults.object(forKey: "lastResetDate") as? Date {
            if !calendar.isDateInToday(lastReset) {
                defaults.set(0, forKey: "todaySessions")
                defaults.set(now, forKey: "lastResetDate")
            }
            let lastWeek = calendar.component(.weekOfYear, from: lastReset)
            let thisWeek = calendar.component(.weekOfYear, from: now)
            if lastWeek != thisWeek {
                defaults.set(0, forKey: "weekSessions")
            }
        } else {
            defaults.set(now, forKey: "lastResetDate")
        }
    }

    /// Records a completed session and returns newly unlocked scenes
    @discardableResult
    func recordSession() -> [Scene] {
        totalStars += 1
        totalSessions += 1
        let today = defaults.integer(forKey: "todaySessions") + 1
        defaults.set(today, forKey: "todaySessions")
        let week = defaults.integer(forKey: "weekSessions") + 1
        defaults.set(week, forKey: "weekSessions")

        var newlyUnlocked: [Scene] = []
        let currentIds = unlockedSceneIds
        for scene in Scene.all {
            if !currentIds.contains(scene.id) && totalSessions >= scene.unlockCount {
                newlyUnlocked.append(scene)
            }
        }
        if !newlyUnlocked.isEmpty {
            unlockedSceneIds = currentIds + newlyUnlocked.map { $0.id }
        }
        return newlyUnlocked
    }
}
