import SwiftUI

enum CardSize {
    case featured, standard, locked
    var height: CGFloat {
        switch self {
        case .featured: return AppConstants.CardHeight.featured
        case .standard: return AppConstants.CardHeight.unlocked
        case .locked:   return AppConstants.CardHeight.locked
        }
    }
}

struct SceneCardView: View {
    let scene: Scene
    let size: CardSize
    var onTap: (() -> Void)? = nil

    @State private var isPressed = false

    var body: some View {
        ZStack {
            // gradient background
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .fill(LinearGradient(colors: scene.cardGradient,
                                     startPoint: .topLeading, endPoint: .bottomTrailing))

            // glassmorphism overlay
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .fill(.ultraThinMaterial.opacity(0.15))

            // gradient border
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .strokeBorder(LinearGradient(colors: scene.cardGradient + [.white.opacity(0.6)],
                                             startPoint: .topLeading, endPoint: .bottomTrailing),
                              lineWidth: 1.5)

            VStack(spacing: AppConstants.Spacing.sm) {
                SceneAnimationView(sceneId: scene.id, size: size == .featured ? 140 : 90)
                    .allowsHitTesting(false)
                Text(scene.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.shadow(.drop(radius: 2)))
                if size == .featured {
                    Text(scene.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppConstants.Spacing.md)

            // locked overlay
            if size == .locked {
                RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                    .fill(.ultraThinMaterial.opacity(0.6))
                VStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                    Text("需\(scene.unlockCount)次专注")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .frame(height: size.height)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            guard size != .locked else { return }
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                onTap?()
            }
        }
        .shadow(color: (scene.cardGradient.first ?? .gray).opacity(0.25),
                radius: 12, x: 0, y: 6)
    }
}
