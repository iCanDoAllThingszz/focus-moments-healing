// DurationPickerView - Duration Selection
import SwiftUI

struct DurationPickerView: View {
    @Binding var duration: Int
    let scene: Scene?
    @Binding var showTimer: Bool
    @Binding var showPicker: Bool
    @EnvironmentObject var timerViewModel: TimerViewModel

    let durations = [15, 25, 45, 60]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                if let scene = scene {
                    Text(scene.emoji)
                        .font(.title)
                    Text(scene.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(.horizontal)

            // Duration options
            VStack(spacing: 12) {
                Text("选择专注时长")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    ForEach(durations, id: \.self) { time in
                        DurationButton(
                            time: time,
                            isSelected: duration == time,
                            action: {
                                duration = time
                            }
                        )
                    }
                }
            }

            // Start button
            Button(action: startFocus) {
                Text("开始专注")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "5B8FB9"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding()
    }

    private func startFocus() {
        showPicker = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let scene = scene {
                timerViewModel.start(duration: duration, scene: scene)
                showTimer = true
                UserPreferences.shared.selectedDuration = duration
            }
        }
    }
}

// MARK: - Duration Button
struct DurationButton: View {
    let time: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(time)")
                    .font(.system(size: 32, weight: .bold))
                Text("分钟")
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 70, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "5B8FB9") : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DurationPickerView(duration: .constant(25), scene: .constant(allScenes[0]), showTimer: .constant(false), showPicker: .constant(true))
        .environmentObject(TimerViewModel())
}
