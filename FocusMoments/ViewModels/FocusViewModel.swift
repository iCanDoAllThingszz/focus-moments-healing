import Foundation
import Observation

@Observable
final class FocusViewModel {
    var totalSeconds: Int = 0
    var remainingSeconds: Int = 0
    var isRunning: Bool = false
    var isCompleted: Bool = false
    var isAbandoned: Bool = false

    private var timer: Timer?

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    var timeString: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func start(durationMinutes: Int) {
        totalSeconds = durationMinutes * 60
        remainingSeconds = totalSeconds
        isRunning = true
        isCompleted = false
        isAbandoned = false
        startTimer()
    }

    func abandon() {
        stopTimer()
        isRunning = false
        isAbandoned = true
    }

    func reset() {
        stopTimer()
        isRunning = false
        isCompleted = false
        isAbandoned = false
        totalSeconds = 0
        remainingSeconds = 0
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.stopTimer()
                self.isRunning = false
                self.isCompleted = true
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
