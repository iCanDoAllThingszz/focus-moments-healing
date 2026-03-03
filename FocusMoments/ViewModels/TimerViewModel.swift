// TimerViewModel - Timer Logic
import Foundation
import Combine
import AVFoundation

class TimerViewModel: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var isCompleted: Bool = false
    @Published var showCompletion: Bool = false
    @Published var currentScene: Scene?
    @Published var currentDuration: Int = 25
    @Published var starsEarned: Int = 0

    private var timer: Timer?
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    private let preferences = UserPreferences.shared
    private let dataManager = DataManager.shared

    // Available durations
    let availableDurations = [15, 25, 45, 60]

    // MARK: - Start Timer
    func start(duration: Int, scene: Scene) {
        currentScene = scene
        currentDuration = duration
        totalSeconds = duration * 60
        remainingSeconds = totalSeconds
        isRunning = true
        isPaused = false
        isCompleted = false

        // Request background task
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }

        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }

        // Play start sound if enabled
        if preferences.soundEnabled {
            playSound(.start)
        }
    }

    // MARK: - Timer Tick
    private func tick() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1

            // Update notification at certain intervals (could add in future)
        } else {
            complete()
        }
    }

    // MARK: - Pause Timer
    func pause() {
        isPaused = true
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Resume Timer
    func resume() {
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    // MARK: - Stop/Cancel Timer
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        remainingSeconds = 0
        endBackgroundTask()
    }

    // MARK: - Complete Focus Session
    func complete() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isCompleted = true
        showCompletion = true

        // Calculate stars earned
        starsEarned = preferences.starsEarned(for: currentDuration)

        // Save to preferences
        preferences.addStars(starsEarned)

        // Save focus session to CoreData
        if let scene = currentScene {
            dataManager.saveFocusSession(sceneName: scene.name, duration: currentDuration, isCompleted: true)
        }

        // Play completion sound if enabled
        if preferences.soundEnabled {
            playSound(.complete)
        }

        // Vibrate if enabled
        if preferences.vibrationEnabled {
            triggerHaptic(.success)
        }

        endBackgroundTask()
    }

    // MARK: - End Background Task
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }

    // MARK: - Format Time
    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Progress
    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    // MARK: - Reset
    func reset() {
        stop()
        isCompleted = false
        showCompletion = false
        currentScene = nil
        starsEarned = 0
    }

    // MARK: - Sound Effects
    enum SoundType {
        case start
        case complete
        case tick
    }

    private func playSound(_ type: SoundType) {
        // Using system sounds for now
        AudioServicesPlaySystemSound(1007) // Default notification sound
    }

    // MARK: - Haptic Feedback
    private func triggerHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
