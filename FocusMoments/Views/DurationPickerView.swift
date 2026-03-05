import SwiftUI

struct FocusRoute: Hashable {
    let scene: Scene
    let durationMinutes: Int
}

struct DurationPickerView: View {
    let scene: Scene
    @Binding var path: NavigationPath
    var homeVM: HomeViewModel

    @State private var selectedMinutes: Int = 25
    @State private var customMinutes: Int = 25
    @State private var useCustom: Bool = false

    let presets = [15, 25, 45, 60]

    var effectiveMinutes: Int { useCustom ? customMinutes : selectedMinutes }

    var body: some View {
        ZStack {
            LinearGradient(colors: scene.bgGradient,
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: AppConstants.Spacing.xl) {
                // preview animation
                SceneAnimationView(sceneId: scene.id, size: 120)
                    .frame(width: 120, height: 120)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 6) {
                    Text(scene.name)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)
                    Text("选择专注时长")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                }

                // preset buttons
                HStack(spacing: AppConstants.Spacing.md) {
                    ForEach(presets, id: \.self) { mins in
                        DurationButton(minutes: mins, isSelected: !useCustom && selectedMinutes == mins) {
                            useCustom = false
                            selectedMinutes = mins
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                }

                // custom picker
                VStack(spacing: AppConstants.Spacing.sm) {
                    Toggle("自定义时长", isOn: $useCustom)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white)
                        .tint(scene.accentColor)
                        .padding(.horizontal)

                    if useCustom {
                        HStack {
                            Button { customMinutes = max(1, customMinutes - 5) } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2).foregroundStyle(.white.opacity(0.8))
                            }
                            Text("\(customMinutes) 分钟")
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 100)
                            Button { customMinutes = min(120, customMinutes + 5) } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2).foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Radius.chip))
                    }
                }

                // start button
                Button {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    path.append(FocusRoute(scene: scene, durationMinutes: effectiveMinutes))
                } label: {
                    HStack(spacing: AppConstants.Spacing.sm) {
                        Image(systemName: "play.fill")
                        Text("开始专注 \(effectiveMinutes)分钟")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(colors: scene.cardGradient,
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.button))
                    .shadow(color: (scene.accentColor).opacity(0.4), radius: 12, y: 6)
                }
                .padding(.horizontal, AppConstants.Spacing.md)
            }
            .padding(AppConstants.Spacing.lg)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct DurationButton: View {
    let minutes: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("\(minutes)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                Text("分钟")
                    .font(.system(.caption2, design: .rounded))
            }
            .foregroundStyle(isSelected ? .white : .white.opacity(0.7))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected
                    ? AnyShapeStyle(.regularMaterial)
                    : AnyShapeStyle(.ultraThinMaterial),
                in: Circle()
            )
        }
    }
}
