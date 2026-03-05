import SwiftUI

struct UnlockPopupView: View {
    let scene: Scene
    var onDismiss: () -> Void

    @State private var appear = false
    @State private var confettiPhase: Double = 0

    var body: some View {
        ZStack {
            // backdrop
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            // confetti
            TimelineView(.animation) { timeline in
                Canvas { ctx, sz in
                    let t = timeline.date.timeIntervalSinceReferenceDate
                    let colors: [Color] = [.red,.orange,.yellow,.green,.blue,.purple,.pink]
                    for i in 0..<60 {
                        let seed = Double(i * 137)
                        let x = sz.width * ((seed * 0.618).truncatingRemainder(dividingBy: 1.0))
                        let rawY = (seed * 0.382).truncatingRemainder(dividingBy: 1.0)
                        let y = sz.height * fmod(rawY + t * (0.2 + Double(i % 5) * 0.05), 1.0)
                        let color = colors[i % colors.count]
                        let r: CGFloat = 4
                        ctx.fill(Path(ellipseIn: CGRect(x:x-r, y:y-r, width:r*2, height:r*2)),
                                 with: .color(color.opacity(0.8)))
                    }
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)

            // card
            VStack(spacing: AppConstants.Spacing.lg) {
                Text("🎉 新场景解锁！")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                SceneAnimationView(sceneId: scene.id, size: 150)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 6) {
                    Text(scene.name)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                    Text(scene.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Button {
                    let n = UINotificationFeedbackGenerator()
                    n.notificationOccurred(.success)
                    onDismiss()
                } label: {
                    Text("太棒了！")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: scene.cardGradient,
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Radius.button))
                }
            }
            .padding(AppConstants.Spacing.xl)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, AppConstants.Spacing.xl)
            .scaleEffect(appear ? 1 : 0.7)
            .opacity(appear ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appear = true
            }
        }
    }
}
