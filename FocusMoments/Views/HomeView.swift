import SwiftUI

struct HomeView: View {
    @State private var homeVM = HomeViewModel()
    @State private var path = NavigationPath()
    @State private var bgPhase: Bool = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // animated background
                LinearGradient(
                    colors: bgPhase
                        ? [Color(hex:"F0E6FF"), Color(hex:"E6F0FF"), Color(hex:"E6FFF0")]
                        : [Color(hex:"FFF0E6"), Color(hex:"F0FFE6"), Color(hex:"E6E6FF")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: bgPhase)

                ScrollView {
                    VStack(spacing: AppConstants.Spacing.lg) {
                        // header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("专注时光")
                                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                                Text("让每一刻都有意义")
                                    .font(.system(.subheadline, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundStyle(Color(hex:"957DAD"))
                        }
                        .padding(.horizontal, AppConstants.Spacing.md)
                        .padding(.top, AppConstants.Spacing.md)

                        // stats row
                        HStack(spacing: AppConstants.Spacing.sm) {
                            StatChip(label: "今日", value: homeVM.todaySessions, icon: "sun.max.fill", color: Color(hex:"F9844A"))
                            StatChip(label: "本周", value: homeVM.weekSessions, icon: "calendar", color: Color(hex:"4A90D9"))
                            StatChip(label: "总计", value: homeVM.totalSessions, icon: "checkmark.circle.fill", color: Color(hex:"52B788"))
                            StatChip(label: "星星", value: homeVM.totalStars, icon: "star.fill", color: Color(hex:"FFD700"))
                        }
                        .padding(.horizontal, AppConstants.Spacing.md)

                        // featured scene
                        Text("推荐场景")
                            .font(.system(.headline, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, AppConstants.Spacing.md)

                        SceneCardView(scene: homeVM.featuredScene, size: .featured) {
                            path.append(homeVM.featuredScene)
                        }
                        .padding(.horizontal, AppConstants.Spacing.md)

                        // unlocked scenes
                        if homeVM.unlockedScenes.count > 1 {
                            Text("已解锁")
                                .font(.system(.headline, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, AppConstants.Spacing.md)

                            LazyVGrid(columns: columns, spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.unlockedScenes.filter { $0.id != homeVM.featuredScene.id }) { scene in
                                    SceneCardView(scene: scene, size: .standard) {
                                        path.append(scene)
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.md)
                        }

                        // locked scenes
                        if !homeVM.lockedScenes.isEmpty {
                            Text("待解锁")
                                .font(.system(.headline, design: .rounded))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, AppConstants.Spacing.md)

                            LazyVGrid(columns: columns, spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.lockedScenes) { scene in
                                    SceneCardView(scene: scene, size: .locked)
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.md)
                        }

                        Spacer(minLength: AppConstants.Spacing.xxl)
                    }
                }
            }
            .navigationDestination(for: Scene.self) { scene in
                DurationPickerView(scene: scene, path: $path, homeVM: homeVM)
            }
            .navigationDestination(for: FocusRoute.self) { route in
                FocusView(route: route, path: $path, homeVM: homeVM)
            }
            .navigationDestination(for: CompletionRoute.self) { route in
                CompletionView(route: route, path: $path, homeVM: homeVM)
            }
            .overlay {
                if homeVM.showUnlockPopup, let scene = homeVM.pendingUnlockScene {
                    UnlockPopupView(scene: scene) {
                        homeVM.dismissUnlock()
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: homeVM.showUnlockPopup)
        }
        .onAppear { bgPhase = true }
    }
}

struct StatChip: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text("\(value)")
                .font(.system(.headline, design: .rounded, weight: .bold))
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppConstants.Spacing.sm)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Radius.chip))
    }
}
