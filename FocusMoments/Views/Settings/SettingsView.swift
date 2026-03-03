// SettingsView - Settings
import SwiftUI

struct SettingsView: View {
    @StateObject private var preferences = UserPreferences.shared
    @EnvironmentObject var dataManager: DataManager
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                // Timer settings
                Section {
                    Toggle("显示计时器", isOn: $preferences.showTimer)
                    Toggle("声音提醒", isOn: $preferences.soundEnabled)
                    Toggle("振动反馈", isOn: $preferences.vibrationEnabled)
                } header: {
                    Text("专注设置")
                }

                // Data section
                Section {
                    HStack {
                        Text("累计专注次数")
                        Spacer()
                        Text("\(dataManager.totalSessionCount) 次")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("累计专注时长")
                        Spacer()
                        Text("\(dataManager.totalFocusMinutes) 分钟")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("累计获得星星")
                        Spacer()
                        Text("\(preferences.totalStars) ⭐")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("数据统计")
                }

                // About section
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("最低支持系统")
                        Spacer()
                        Text("iOS 17.0")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("关于")
                }

                // Danger zone
                Section {
                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("重置所有数据")
                        }
                    }
                } header: {
                    Text("危险区域")
                }
            }
            .navigationTitle("设置")
            .alert("确认重置？", isPresented: $showResetAlert) {
                Button("取消", role: .cancel) {}
                Button("重置", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("这将清除所有专注记录、星星和成就数据。此操作不可撤销。")
            }
        }
    }

    private func resetAllData() {
        // Reset preferences
        preferences.resetAllData()

        // Clear CoreData
        let context = dataManager.container.viewContext
        for session in dataManager.focusSessions {
            context.delete(session)
        }
        try? context.save()

        // Refresh data manager
        dataManager.fetchAllSessions()
    }
}

#Preview {
    SettingsView()
        .environmentObject(DataManager.shared)
}
