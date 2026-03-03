// CalendarView - Calendar Statistics
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var statsViewModel: StatsViewModel
    @State private var selectedDate: Date?
    @State private var showSessionDetail = false

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats cards
                    statsCards

                    // Calendar
                    calendarSection

                    // Selected date sessions
                    if let date = selectedDate {
                        selectedDateSessions(date: date)
                    }
                }
                .padding()
            }
            .background(Color(hex: "F5F5F5"))
            .navigationTitle("专注统计")
            .onAppear {
                statsViewModel.refresh()
            }
        }
    }

    // MARK: - Stats Cards
    private var statsCards: some View {
        HStack(spacing: 12) {
            StatCard(title: "今日", value: "\(statsViewModel.todaySessions)", unit: "次", color: Color(hex: "5B8FB9"))
            StatCard(title: "本周", value: "\(statsViewModel.weekSessions)", unit: "次", color: Color(hex: "301E67"))
            StatCard(title: "总计", value: "\(statsViewModel.totalSessions)", unit: "次", color: Color(hex: "5B8FB9"))
        }
    }

    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: 16) {
            // Month navigation
            HStack {
                Button(action: { statsViewModel.previousMonth() }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(Color(hex: "5B8FB9"))
                }

                Spacer()

                Text(statsViewModel.monthName)
                    .font(.headline)

                Spacer()

                Button(action: { statsViewModel.nextMonth() }) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(Color(hex: "5B8FB9"))
                }
            }
            .padding(.horizontal)

            // Weekday headers
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            calendarGrid
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        let firstWeekday = statsViewModel.firstWeekdayOfMonth
        let days = statsViewModel.daysInMonth()

        return LazyVGrid(columns: columns, spacing: 8) {
            // Empty cells for days before first of month
            ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                Color.clear
                    .frame(height: 40)
            }

            // Day cells
            ForEach(days, id: \.self) { date in
                DayCell(
                    date: date,
                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate ?? Date.distantFuture),
                    hasSession: statsViewModel.hasSession(on: date),
                    isToday: Calendar.current.isDateInToday(date)
                ) {
                    selectedDate = date
                }
            }
        }
    }

    // MARK: - Selected Date Sessions
    private func selectedDateSessions(date: Date) -> some View {
        let sessions = statsViewModel.sessions(for: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"

        return VStack(alignment: .leading, spacing: 12) {
            Text(formatter.string(from: date))
                .font(.headline)

            if sessions.isEmpty {
                Text("当日无专注记录")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(sessions, id: \.id) { session in
                    SessionRow(session: session)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)

                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Day Cell
struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasSession: Bool
    let isToday: Bool
    let action: () -> Void

    private var day: Int {
        Calendar.current.component(.day, from: date)
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                // Selection background
                if isSelected {
                    Circle()
                        .fill(Color(hex: "5B8FB9"))
                } else if isToday {
                    Circle()
                        .stroke(Color(hex: "5B8FB9"), lineWidth: 2)
                }

                VStack(spacing: 2) {
                    Text("\(day)")
                        .font(.body)
                        .fontWeight(isToday ? .bold : .regular)
                        .foregroundColor(isSelected ? .white : (hasSession ? Color(hex: "5B8FB9") : .primary))

                    // Session indicator
                    if hasSession {
                        Circle()
                            .fill(isSelected ? Color.white : Color(hex: "5B8FB9"))
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .frame(width: 40, height: 40)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Session Row
struct SessionRow: View {
    let session: FocusSession

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.sceneName ?? "未知场景")
                    .font(.headline)

                if let date = session.date {
                    Text(formatTime(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(session.duration) 分钟")
                .font(.subheadline)
                .foregroundColor(Color(hex: "5B8FB9"))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
        .environmentObject(StatsViewModel())
}
