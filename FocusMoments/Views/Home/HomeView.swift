// HomeView - Scene Selection
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sceneViewModel: SceneViewModel
    @EnvironmentObject var statsViewModel: StatsViewModel
    @EnvironmentObject var timerViewModel: TimerViewModel
    @Binding var selectedScene: Scene?
    @Binding var showTimer: Bool
    @State private var showDurationPicker = false
    @State private var selectedDuration: Int = 25

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with stats
                    headerSection

                    // Scene grid
                    sceneGrid

                    // Next unlock info
                    if let nextInfo = sceneViewModel.nextUnlockInfo {
                        nextUnlockSection(info: nextInfo)
                    }
                }
                .padding()
            }
            .background(Color(hex: "F5F5F5"))
            .navigationTitle("专注时光")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(sceneViewModel.totalStars)")
                            .font(.headline)
                    }
                }
            }
        }
        .sheet(isPresented: $showDurationPicker) {
            DurationPickerView(duration: $selectedDuration, scene: selectedScene, showTimer: $showTimer, showPicker: $showDurationPicker)
                .presentationDetents([.height(300)])
                .environmentObject(timerViewModel)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("今日专注")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(statsViewModel.todaySessions)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color(hex: "5B8FB9"))
                        Text("次")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("本周专注")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(statsViewModel.weekSessions)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(Color(hex: "5B8FB9"))
                        Text("次")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }

    // MARK: - Scene Grid
    private var sceneGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择场景")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sceneViewModel.scenes) { scene in
                    SceneCard(scene: scene) {
                        if scene.isUnlocked {
                            selectedScene = scene
                            selectedDuration = UserPreferences.shared.selectedDuration
                            showDurationPicker = true
                        }
                    }
                }
            }
        }
    }

    // MARK: - Next Unlock Section
    private func nextUnlockSection(info: (name: String, requirement: Int, current: Int)) -> some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "lock.open.fill")
                    .foregroundColor(Color(hex: "5B8FB9"))
                Text("距离解锁「\(info.name)」还差 \(info.requirement - info.current) 次专注")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: Double(info.current), total: Double(info.requirement))
                .tint(Color(hex: "5B8FB9"))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Scene Card
struct SceneCard: View {
    let scene: Scene
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Scene emoji/icon
                ZStack {
                    if scene.isUnlocked {
                        Circle()
                            .fill(Color(hex: "5B8FB9").opacity(0.1))
                            .frame(width: 70, height: 70)
                    }

                    Text(scene.isUnlocked ? scene.emoji : "🔒")
                        .font(.system(size: 36))
                }

                // Scene name
                Text(scene.name)
                    .font(.headline)
                    .foregroundColor(scene.isUnlocked ? .primary : .secondary)

                // Description
                if scene.isUnlocked {
                    Text(scene.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                } else {
                    Text("\(scene.unlockRequirement)次解锁")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(scene.isUnlocked ? Color.white : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(scene.isUnlocked ? Color(hex: "5B8FB9").opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView(selectedScene: .constant(nil), showTimer: .constant(false))
        .environmentObject(SceneViewModel())
        .environmentObject(StatsViewModel())
        .environmentObject(TimerViewModel())
}
