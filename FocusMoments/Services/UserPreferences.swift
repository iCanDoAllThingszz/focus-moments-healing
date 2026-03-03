// UserPreferences - UserDefaults Wrapper
import Foundation

class UserPreferences: ObservableObject {
    static let shared = UserPreferences()

    private let defaults = UserDefaults.standard

    // Keys
    private enum Keys {
        static let unlockedScenes = "unlockedScenes"
        static let totalStars = "totalStars"
        static let unlockedAchievements = "unlockedAchievements"
        static let selectedDuration = "selectedDuration"
        static let soundEnabled = "soundEnabled"
        static let vibrationEnabled = "vibrationEnabled"
        static let showTimer = "showTimer"
        static let hasOnboarded = "hasOnboarded"
    }

    @Published var unlockedScenes: [String] {
        didSet {
            defaults.set(unlockedScenes, forKey: Keys.unlockedScenes)
        }
    }

    @Published var totalStars: Int {
        didSet {
            defaults.set(totalStars, forKey: Keys.totalStars)
        }
    }

    @Published var unlockedAchievementIds: [String] {
        didSet {
            defaults.set(unlockedAchievementIds, forKey: Keys.unlockedAchievements)
        }
    }

    @Published var selectedDuration: Int {
        didSet {
            defaults.set(selectedDuration, forKey: Keys.selectedDuration)
        }
    }

    @Published var soundEnabled: Bool {
        didSet {
            defaults.set(soundEnabled, forKey: Keys.soundEnabled)
        }
    }

    @Published var vibrationEnabled: Bool {
        didSet {
            defaults.set(vibrationEnabled, forKey: Keys.vibrationEnabled)
        }
    }

    @Published var showTimer: Bool {
        didSet {
            defaults.set(showTimer, forKey: Keys.showTimer)
        }
    }

    @Published var hasOnboarded: Bool {
        didSet {
            defaults.set(hasOnboarded, forKey: Keys.hasOnboarded)
        }
    }

    private init() {
        // Load initial values
        self.unlockedScenes = defaults.stringArray(forKey: Keys.unlockedScenes) ?? initialSceneNames
        self.totalStars = defaults.integer(forKey: Keys.totalStars)
        self.unlockedAchievementIds = defaults.stringArray(forKey: Keys.unlockedAchievements) ?? []
        self.selectedDuration = defaults.integer(forKey: Keys.selectedDuration)
        if self.selectedDuration == 0 {
            self.selectedDuration = 25 // Default 25 minutes
        }
        self.soundEnabled = defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true
        self.vibrationEnabled = defaults.object(forKey: Keys.vibrationEnabled) as? Bool ?? true
        self.showTimer = defaults.object(forKey: Keys.showTimer) as? Bool ?? true
        self.hasOnboarded = defaults.bool(forKey: Keys.hasOnboarded)
    }

    // MARK: - Stars earned per session based on duration
    func starsEarned(for duration: Int) -> Int {
        switch duration {
        case 15: return 1
        case 25: return 2
        case 45: return 3
        case 60: return 5
        default: return 1
        }
    }

    // MARK: - Add Stars
    func addStars(_ count: Int) {
        totalStars += count
    }

    // MARK: - Unlock Scene
    func unlockScene(_ sceneName: String) {
        if !unlockedScenes.contains(sceneName) {
            unlockedScenes.append(sceneName)
        }
    }

    // MARK: - Check if Scene is Unlocked
    func isSceneUnlocked(_ sceneName: String) -> Bool {
        unlockedScenes.contains(sceneName)
    }

    // MARK: - Unlock Achievement
    func unlockAchievement(_ achievementId: String) {
        if !unlockedAchievementIds.contains(achievementId) {
            unlockedAchievementIds.append(achievementId)
        }
    }

    // MARK: - Check if Achievement is Unlocked
    func isAchievementUnlocked(_ achievementId: String) -> Bool {
        unlockedAchievementIds.contains(achievementId)
    }

    // MARK: - Reset All Data
    func resetAllData() {
        unlockedScenes = initialSceneNames
        totalStars = 0
        unlockedAchievementIds = []
        selectedDuration = 25
        soundEnabled = true
        vibrationEnabled = true
        showTimer = true
    }
}
