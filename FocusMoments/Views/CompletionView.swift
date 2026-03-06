import SwiftUI

struct CompletionView: View {
    let route: CompletionRoute
    @Binding var path: NavigationPath
    var homeVM: HomeViewModel

    @State private var starScale: CGFloat = 0
    @State private var starOpacity: Double = 0
    @State private var encouragement: String = ""

    var body: some View {
        ZStack {
            LinearGradient(colors: route.scene.bgGradient,
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            // star burst particles
            TimelineView(.animation) { timeline in
                Canvas { ctx, sz in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    for i in 0..<30 {
                        let angle = Double(i) / 30.0 * .pi * 2
                        let distance = sz.width * 0.35 * min(1.0, t / 1.5)
                        let x = sz.width/2 + cos(angle) * distance
                        let y = sz.height/2 + sin(angle) * distance - sz.height * 0.1
                        let alpha = max(0, 1.0 - t / 2.5)
                        let r: CGFloat = 3
                        ctx.fill(Path(ellipseIn: CGRect(x:x-r, y:y-r, width:r*2, height:r*2)),
                                 with: .color(Color(hex:"FFD700").opacity(alpha)))
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            VStack(spacing: AppConstants.Spacing.xl) {
                Spacer()

                // star
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex:"FFD700"), Color(hex:"FFA500")],
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .scaleEffect(starScale)
                    .opacity(starOpacity)
                    .shadow(color: Color(hex:"FFD700").opacity(0.5), radius: 20)

                // +1 star
                Text("+1 ⭐️")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)

                // encouragement
                Text(encouragement)
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // scene preview
                SceneAnimationView(sceneId: route.scene.id,
                                   size: 150,
                                   progress: 1.0,
                                   celebrating: true)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                Text("专注了 \(route.durationMinutes) 分钟")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()

                // return button
                Button {
                    homeVM.handleSessionComplete()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    path.removeLast(path.count)
                } label: {
                    Text("完成")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(colors: route.scene.cardGradient,
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.button))
                }
                .padding(.horizontal, AppConstants.Spacing.xl)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            encouragement = AppConstants.Encouragements.messages.randomElement() ?? ""
            let n = UINotificationFeedbackGenerator()
            n.notificationOccurred(.success)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.2)) {
                starScale = 1.0
                starOpacity = 1.0
            }
        }
    }
}
