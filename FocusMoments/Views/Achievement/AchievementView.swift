// AchievementView - Achievements
import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var statsViewModel: StatsViewModel
    @EnvironmentObject var dataManager: DataManager

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress header
                    progressHeader

                    // Achievement grid
                    achievementGrid
                }
                .padding()
            }
            .background(Color(hex: "F5F5F5"))
            .navigationTitle("成就")
            .onAppear {
                statsViewModel.checkAchievements()
            }
        }
    }

    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: 16) {
            // Progress ring
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "5B8FB9"), Color(hex: "301E67")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(statsViewModel.unlockedAchievementsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "5B8FB9"))

                    Text("/ \(statsViewModel.achievements.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Title
            Text("已完成 \(Int(progress * 100))%")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Achievement Grid
    private var achievementGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(statsViewModel.achievements) { achievement in
                AchievementCard(achievement: achievement)
            }
        }
    }

    private var progress: Double {
        guard !statsViewModel.achievements.isEmpty else { return 0 }
        return Double(statsViewModel.unlockedAchievementsCount) / Double(statsViewModel.achievements.count)
    }
}

// MARK: - Achievement Card
struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color(hex: "5B8FB9").opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)

                Text(achievement.icon)
                    .font(.title)
                    .opacity(achievement.isUnlocked ? 1 : 0.3)
            }

            // Title
            Text(achievement.title)
                .font(.headline)
                .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                .lineLimit(1)

            // Description
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            // Status
            if achievement.isUnlocked {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("已解锁")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            } else {
                Text("未解锁")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(achievement.isUnlocked ? Color(hex: "5B8FB9").opacity(0.3) : Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AchievementView()
        .environmentObject(StatsViewModel())
        .environmentObject(DataManager.shared)
}
