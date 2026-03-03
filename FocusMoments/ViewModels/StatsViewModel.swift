// StatsViewModel - Statistics
import Foundation
import Combine

class StatsViewModel: ObservableObject {
    @Published var datesWithSessions: Set<Date> = []
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date?

    private let dataManager = DataManager.shared

    init() {
        refresh()
    }

    // MARK: - Refresh Data
    func refresh() {
        datesWithSessions = dataManager.datesWithSessions()
    }

    // MARK: - Get sessions for selected date
    func sessions(for date: Date) -> [FocusSession] {
        dataManager.sessions(for: date)
    }

    // MARK: - Get total sessions
    var totalSessions: Int {
        dataManager.totalSessionCount
    }

    // MARK: - Get today's sessions
    var todaySessions: Int {
        dataManager.todaySessionCount
    }

    // MARK: - Get this week's sessions
    var weekSessions: Int {
        dataManager.weekSessionCount
    }

    // MARK: - Get total focus minutes
    var totalMinutes: Int {
        dataManager.totalFocusMinutes
    }

    // MARK: - Get total focus hours
    var totalHours: Double {
        Double(totalMinutes) / 60.0
    }

    // MARK: - Check if date has sessions
    func hasSession(on date: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return datesWithSessions.contains(startOfDay)
    }

    // MARK: - Get month name
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }

    // MARK: - Navigate to previous month
    func previousMonth() {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    // MARK: - Navigate to next month
    func nextMonth() {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    // MARK: - Get days in current month
    func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: currentMonth) else {
            return []
        }

        return range.compactMap { day -> Date? in
            var dateComponents = components
            dateComponents.day = day
            return calendar.date(from: dateComponents)
        }
    }

    // MARK: - Get first weekday of month (1 = Sunday, 7 = Saturday)
    var firstWeekdayOfMonth: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDay = calendar.date(from: components) else { return 1 }
        return calendar.component(.weekday, from: firstDay)
    }

    // MARK: - Get achievements data
    var achievements: [Achievement] {
        let preferences = UserPreferences.shared
        return allAchievements.map { achievement in
            var mutableAchievement = achievement
            mutableAchievement.isUnlocked = preferences.isAchievementUnlocked(achievement.id.uuidString)
            return mutableAchievement
        }
    }

    // MARK: - Check and unlock achievements
    func checkAchievements() {
        let preferences = UserPreferences.shared

        for achievement in allAchievements {
            if preferences.isAchievementUnlocked(achievement.id.uuidString) {
                continue
            }

            var shouldUnlock = false

            switch achievement.title {
            case "初次专注":
                shouldUnlock = totalSessions >= 1
            case "5次专注":
                shouldUnlock = totalSessions >= 5
            case "10次专注":
                shouldUnlock = totalSessions >= 10
            case "25次专注":
                shouldUnlock = totalSessions >= 25
            case "50次专注":
                shouldUnlock = totalSessions >= 50
            case "100次专注":
                shouldUnlock = totalSessions >= 100
            case "累计10小时":
                shouldUnlock = totalMinutes >= 600
            case "累计50小时":
                shouldUnlock = totalMinutes >= 3000
            default:
                break
            }

            if shouldUnlock {
                preferences.unlockAchievement(achievement.id.uuidString)
            }
        }
    }

    // MARK: - Get unlocked achievements count
    var unlockedAchievementsCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
}
