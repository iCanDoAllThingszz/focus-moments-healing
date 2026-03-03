// Achievement Model
import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let requirement: Int
    var isUnlocked: Bool

    init(id: UUID = UUID(), title: String, description: String, icon: String, requirement: Int, isUnlocked: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.requirement = requirement
        self.isUnlocked = isUnlocked
    }
}

// All achievements
let allAchievements: [Achievement] = [
    Achievement(title: "初次专注", description: "完成你的第一次专注", icon: "🌟", requirement: 1),
    Achievement(title: "5次专注", description: "完成5次专注", icon: "⭐", requirement: 5),
    Achievement(title: "10次专注", description: "完成10次专注", icon: "🌈", requirement: 10),
    Achievement(title: "25次专注", description: "完成25次专注", icon: "💫", requirement: 25),
    Achievement(title: "50次专注", description: "完成50次专注", icon: "💎", requirement: 50),
    Achievement(title: "100次专注", description: "完成100次专注", icon: "👑", requirement: 100),
    Achievement(title: "早起鸟儿", description: "在早上6点前开始专注", icon: "🐦", requirement: 1),
    Achievement(title: "夜猫子", description: "在晚上10点后开始专注", icon: "🦉", requirement: 1),
    Achievement(title: "连续3天", description: "连续3天都有专注记录", icon: "🔥", requirement: 3),
    Achievement(title: "连续7天", description: "连续7天都有专注记录", icon: "🎯", requirement: 7),
    Achievement(title: "累计10小时", description: "累计专注时长达到10小时", icon: "⏰", requirement: 600),
    Achievement(title: "累计50小时", description: "累计专注时长达到50小时", icon: "🏆", requirement: 3000)
]
