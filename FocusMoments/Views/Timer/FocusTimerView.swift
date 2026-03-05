// FocusTimerView - Focus Timer Screen
import SwiftUI

struct FocusTimerView: View {
    let scene: Scene
    @Binding var isPresented: Bool
    @EnvironmentObject var timerViewModel: TimerViewModel
    @EnvironmentObject var sceneViewModel: SceneViewModel
    @EnvironmentObject var statsViewModel: StatsViewModel
    @State private var showStopConfirmation = false
    @State private var showCompletion = false

    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient

            // Content
            VStack(spacing: 40) {
                Spacer()

                // Scene emoji (large)
                Text(scene.emoji)
                    .font(.system(size: 80))

                // Scene name
                Text(scene.name)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))

                Spacer()

                // Timer display
                timerDisplay

                // Progress bar
                progressBar

                Spacer()

                // Control buttons
                controlButtons

                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .onChange(of: timerViewModel.showCompletion) { _, newValue in
            if newValue {
                showCompletion = true
            }
        }
        .fullScreenCover(isPresented: $showCompletion) {
            CompletionView(isPresented: $isPresented)
                .environmentObject(timerViewModel)
                .environmentObject(sceneViewModel)
                .environmentObject(statsViewModel)
        }
        .alert("确认退出？", isPresented: $showStopConfirmation) {
            Button("继续专注", role: .cancel) {}
            Button("退出", role: .destructive) {
                timerViewModel.stop()
                isPresented = false
            }
        } message: {
            Text("退出将不保存本次专注记录")
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 {
                        showStopConfirmation = true
                    }
                }
        )
    }

    // MARK: - Background Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "5B8FB9"),
                Color(hex: "301E67"),
                Color(hex: "03001C")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    // MARK: - Timer Display
    private var timerDisplay: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.white.opacity(0.2), lineWidth: 8)
                .frame(width: 250, height: 250)

            // Progress circle
            Circle()
                .trim(from: 0, to: timerViewModel.progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 250, height: 250)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: timerViewModel.progress)

            // Time text
            VStack(spacing: 8) {
                Text(timerViewModel.formattedTime)
                    .font(.system(size: 56, weight: .light, design: .monospaced))
                    .foregroundColor(.white)

                if timerViewModel.isPaused {
                    Text("已暂停")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }

    // MARK: - Progress Bar
    private var progressBar: some View {
        VStack(spacing: 8) {
            ProgressView(value: timerViewModel.progress)
                .tint(.white)
                .scaleEffect(x: 1, y: 2, anchor: .center)

            Text("\(Int(timerViewModel.progress * 100))% 完成")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 40)
    }

    // MARK: - Control Buttons
    private var controlButtons: some View {
        HStack(spacing: 40) {
            // Pause/Resume button
            Button(action: togglePause) {
                Image(systemName: timerViewModel.isPaused ? "play.fill" : "pause.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.white.opacity(0.2)))
            }

            // Stop button
            Button(action: { showStopConfirmation = true }) {
                Image(systemName: "stop.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(Color.white.opacity(0.2)))
            }
        }
    }

    private func togglePause() {
        if timerViewModel.isPaused {
            timerViewModel.resume()
        } else {
            timerViewModel.pause()
        }
    }
}

#Preview {
    FocusTimerView(scene: allScenes[0], isPresented: .constant(true))
        .environmentObject(TimerViewModel())
        .environmentObject(SceneViewModel())
        .environmentObject(StatsViewModel())
}
