// CompletionView - Session Complete Screen
import SwiftUI

struct CompletionView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var sceneViewModel: SceneViewModel
    @EnvironmentObject var statsViewModel: StatsViewModel

    @State private var animateStars = false
    @State private var showContent = false

    var body: some View {
        ZStack {
            // Background
            backgroundGradient

            VStack(spacing: 30) {
                Spacer()

                // Completion animation area
                completionAnimation

                // Congratulations text
                congratsText

                // Stars earned
                starsEarnedSection

                // Stats summary
                statsSummary

                // Next unlock hint
                nextUnlockHint

                Spacer()

                // Action buttons
                actionButtons
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                showContent = true
            }
            withAnimation(.spring().delay(0.3).repeatForever(autoreverses: true)) {
                animateStars = true
            }

            // Refresh data
            sceneViewModel.refresh()
            statsViewModel.checkAchievements()
        }
    }

    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "5B8FB9"),
                Color(hex: "301E67")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Completion Animation
    private var completionAnimation: some View {
        ZStack {
            // Animated circles
            ForEach(0..<3) { i in
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: CGFloat(100 + i * 50), height: CGFloat(100 + i * 50))
                    .scaleEffect(animateStars ? 1.2 : 1.0)
                    .opacity(animateStars ? 0 : 0.5)
            }

            // Checkmark
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .shadow(color: .white.opacity(0.5), radius: 10)
        }
    }

    // MARK: - Congratulations Text
    private var congratsText: some View {
        VStack(spacing: 8) {
            Text("太棒了！")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)

            Text("你完成了一次专注")
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
        }
        .opacity(showContent ? 1 : 0)
        .offset(y: showContent ? 0 : 20)
    }

    // MARK: - Stars Earned Section
    private var starsEarnedSection: some View {
        HStack(spacing: 8) {
            ForEach(0..<timerViewModel.starsEarned, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
            Text("+\(timerViewModel.starsEarned) 星星")
                .font(.headline)
                .foregroundColor(.white)
        }
        .scaleEffect(animateStars ? 1.1 : 1.0)
    }

    // MARK: - Stats Summary
    private var statsSummary: some View {
        VStack(spacing: 12) {
            HStack {
                Text("今日专注")
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(statsViewModel.todaySessions) 次")
                    .foregroundColor(.white)
            }

            HStack {
                Text("本周专注")
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(statsViewModel.weekSessions) 次")
                    .foregroundColor(.white)
            }

            HStack {
                Text("累计星星")
                    .foregroundColor(.white.opacity(0.7))
                Spacer()
                Text("\(sceneViewModel.totalStars) ⭐")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .opacity(showContent ? 1 : 0)
    }

    // MARK: - Next Unlock Hint
    @ViewBuilder
    private var nextUnlockHint: some View {
        if let nextInfo = sceneViewModel.nextUnlockInfo {
            VStack(spacing: 4) {
                Text("距离「\(nextInfo.name)」还需 \(nextInfo.requirement - nextInfo.current) 次专注")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                ProgressView(value: Double(nextInfo.current), total: Double(nextInfo.requirement))
                    .tint(.white)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
            .opacity(showContent ? 1 : 0)
        }
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            // Continue focusing
            Button(action: continueFocus) {
                Text("继续专注")
                    .font(.headline)
                    .foregroundColor(Color(hex: "5B8FB9"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            }

            // Done
            Button(action: done) {
                Text("完成")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .opacity(showContent ? 1 : 0)
    }

    private func continueFocus() {
        timerViewModel.reset()
        showContent = false
        isPresented = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // The parent view will handle showing the timer again
        }
    }

    private func done() {
        timerViewModel.reset()
        isPresented = false
    }
}

#Preview {
    CompletionView(isPresented: .constant(true))
        .environmentObject(TimerViewModel())
        .environmentObject(SceneViewModel())
        .environmentObject(StatsViewModel())
}
