import SwiftUI

struct CompletionRoute: Hashable {
    let scene: Scene
    let durationMinutes: Int
}

struct FocusView: View {
    let route: FocusRoute
    @Binding var path: NavigationPath
    var homeVM: HomeViewModel

    @State private var focusVM = FocusViewModel()
    @State private var showAbandonAlert = false
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(colors: route.scene.bgGradient,
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // scene animation (60% height)
                    SceneAnimationView(sceneId: route.scene.id,
                                       size: geo.size.height * 0.52,
                                       progress: focusVM.progress)
                        .frame(width: geo.size.width, height: geo.size.height * 0.52)
                        .clipped()

                    Spacer()

                    // timer
                    ZStack {
                        // background ring
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 180, height: 180)

                        // progress ring
                        Circle()
                            .trim(from: 0, to: focusVM.progress)
                            .stroke(
                                AngularGradient(colors: route.scene.cardGradient + [route.scene.accentColor],
                                                center: .center),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 1), value: focusVM.progress)

                        // pulse
                        Circle()
                            .fill(route.scene.accentColor.opacity(0.15))
                            .frame(width: 160, height: 160)
                            .scaleEffect(pulseScale)

                        Text(focusVM.timeString)
                            .font(.system(size: 52, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                    }

                    Spacer()

                    // scene name
                    Text(route.scene.name)
                        .font(.system(.title3, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))

                    Spacer(minLength: 20)

                    // abandon
                    Button {
                        showAbandonAlert = true
                    } label: {
                        Text("放弃")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("确定要放弃吗？", isPresented: $showAbandonAlert) {
            Button("继续专注", role: .cancel) {}
            Button("放弃", role: .destructive) {
                focusVM.abandon()
                path.removeLast(path.count)
            }
        } message: {
            Text("本次专注将不会被记录")
        }
        .onChange(of: focusVM.isCompleted) { _, completed in
            if completed {
                path.append(CompletionRoute(scene: route.scene, durationMinutes: route.durationMinutes))
            }
        }
        .onAppear {
            focusVM.start(durationMinutes: route.durationMinutes)
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.08
            }
        }
        .onDisappear {
            if !focusVM.isCompleted {
                focusVM.abandon()
            }
        }
    }
}
