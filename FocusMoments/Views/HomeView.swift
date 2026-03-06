import SwiftUI

struct HomeView: View {
    @State private var homeVM = HomeViewModel()
    @State private var path = NavigationPath()

    private var isDark: Bool { DataManager.shared.themeStyle == "darkGlass" }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if isDark {
                    DarkGlassBackground()
                } else {
                    SoftOrbBackground()
                }

                ScrollView {
                    VStack(spacing: AppConstants.Spacing.lg) {
                        HomeHeaderView(isDark: isDark)
                            .padding(.horizontal, AppConstants.Spacing.md)
                            .padding(.top, AppConstants.Spacing.sm)

                        StatsRowView(homeVM: homeVM, isDark: isDark)
                            .padding(.horizontal, AppConstants.Spacing.md)

                        SectionLabel("精选场景", isDark: isDark)

                        SceneCardView(scene: homeVM.featuredScene, size: .featured, isDark: isDark) {
                            path.append(homeVM.featuredScene)
                        }
                        .padding(.horizontal, AppConstants.Spacing.md)

                        if homeVM.unlockedScenes.count > 1 {
                            SectionLabel("已解锁", isDark: isDark)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                      spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.unlockedScenes.filter { $0.id != homeVM.featuredScene.id }) { scene in
                                    SceneCardView(scene: scene, size: .standard, isDark: isDark) {
                                        path.append(scene)
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.md)
                        }

                        if !homeVM.lockedScenes.isEmpty {
                            SectionLabel("待解锁", isDark: isDark)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                      spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.lockedScenes) { scene in
                                    SceneCardView(scene: scene, size: .locked, isDark: isDark)
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
                    UnlockPopupView(scene: scene) { homeVM.dismissUnlock() }
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: homeVM.showUnlockPopup)
        }
        .onLongPressGesture(minimumDuration: 0.6) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                DataManager.shared.themeStyle = isDark ? "softOrb" : "darkGlass"
            }
        }
    }
}

// MARK: - Dark Glass Background
struct DarkGlassBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex:"0A0E1A"), Color(hex:"1A0A2E")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            TimelineView(.animation) { tl in
                Canvas { ctx, sz in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    let meshColors: [Color] = [Color(hex:"7B2FBE"), Color(hex:"0096C7"),
                                               Color(hex:"52B788"), Color(hex:"957DAD"),
                                               Color(hex:"F9844A"), Color(hex:"4A90D9")]
                    for i in 0..<6 {
                        let seed = Double(i * 137)
                        let bx = sz.width  * CGFloat((seed * 0.618).truncatingRemainder(dividingBy: 1.0))
                        let by = sz.height * CGFloat((seed * 0.382).truncatingRemainder(dividingBy: 1.0))
                        let drift = CGFloat(sin(t * 0.3 + seed)) * 30
                        let r = sz.width * 0.2
                        ctx.fill(Path(ellipseIn: CGRect(x: bx+drift-r, y: by-r, width: r*2, height: r*2)),
                                 with: .color(meshColors[i].opacity(0.07)))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Soft Orb Background
struct SoftOrbBackground: View {
    var body: some View {
        ZStack {
            Color(hex:"F8F6FF").ignoresSafeArea()
            TimelineView(.animation) { tl in
                Canvas { ctx, sz in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    let orbDefs: [(Color, Double, Double)] = [
                        (Color(hex:"FFB7C5"), 0.25, 0.28),
                        (Color(hex:"B5EAD7"), 0.72, 0.65),
                        (Color(hex:"C7B8EA"), 0.45, 0.82),
                    ]
                    for (color, bx, by) in orbDefs {
                        let ox = sz.width  * CGFloat(bx + sin(t * 0.18 + bx) * 0.08)
                        let oy = sz.height * CGFloat(by + cos(t * 0.22 + by) * 0.06)
                        let r  = sz.width  * CGFloat(0.38)
                        ctx.fill(Path(ellipseIn: CGRect(x: ox-r, y: oy-r, width: r*2, height: r*2)),
                                 with: .color(color.opacity(0.35)))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Header
struct HomeHeaderView: View {
    let isDark: Bool
    private var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "早上好 ☀️" }
        else if h < 18 { return "下午好 🌤" }
        else { return "晚上好 🌙" }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(greeting)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(isDark ? .white.opacity(0.6) : .secondary)
                Text("专注时光")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(isDark ? .white : .primary)
            }
            Spacer()
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(Color(hex:"957DAD"))
                .symbolEffect(.variableColor.iterative)
        }
    }
}

// MARK: - Stats Row
struct StatsRowView: View {
    let homeVM: HomeViewModel
    let isDark: Bool
    var body: some View {
        HStack(spacing: AppConstants.Spacing.sm) {
            StatChip(label: "今日", value: homeVM.todaySessions,
                     icon: "sun.max.fill", color: Color(hex:"F9844A"), isDark: isDark)
            StatChip(label: "本周", value: homeVM.weekSessions,
                     icon: "calendar", color: Color(hex:"4A90D9"), isDark: isDark)
            StatChip(label: "总计", value: homeVM.totalSessions,
                     icon: "checkmark.circle.fill", color: Color(hex:"52B788"), isDark: isDark)
            StatChip(label: "星星", value: homeVM.totalStars,
                     icon: "star.fill", color: Color(hex:"FFD700"), isDark: isDark)
        }
    }
}

// MARK: - Section Label
struct SectionLabel: View {
    let title: String
    let isDark: Bool
    init(_ title: String, isDark: Bool) { self.title = title; self.isDark = isDark }
    var body: some View {
        Text(title)
            .font(.system(.headline, design: .rounded, weight: .semibold))
            .foregroundStyle(isDark ? .white.opacity(0.85) : .primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppConstants.Spacing.md)
    }
}

// MARK: - Stat Chip
struct StatChip: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color
    let isDark: Bool
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.caption).foregroundStyle(color)
            Text("\(value)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(isDark ? .white : .primary)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(isDark ? .white.opacity(0.5) : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppConstants.Spacing.sm)
        .background(
            isDark ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.regularMaterial),
            in: RoundedRectangle(cornerRadius: AppConstants.Radius.chip)
        )
    }
}
