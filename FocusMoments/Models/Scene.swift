// Scene Model
import Foundation

struct Scene: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let emoji: String
    let description: String
    let unlockRequirement: Int
    let animationName: String
    var isUnlocked: Bool

    init(id: UUID = UUID(), name: String, emoji: String, description: String, unlockRequirement: Int, animationName: String, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.description = description
        self.unlockRequirement = unlockRequirement
        self.animationName = animationName
        self.isUnlocked = isUnlocked
    }

    static func == (lhs: Scene, rhs: Scene) -> Bool {
        lhs.id == rhs.id
    }
}

// All 15 scenes data
let allScenes: [Scene] = [
    Scene(name: "小树生长", emoji: "🌱", description: "见证生命的成长", unlockRequirement: 0, animationName: "tree_grow"),
    Scene(name: "小猫午睡", emoji: "😺", description: "慵懒治愈的时光", unlockRequirement: 0, animationName: "cat_sleep"),
    Scene(name: "小鱼成长", emoji: "🐠", description: "自由游动的快乐", unlockRequirement: 0, animationName: "fish_grow"),
    Scene(name: "小鸟筑巢", emoji: "🐦", description: "勤劳温馨的家", unlockRequirement: 5, animationName: "bird_nest"),
    Scene(name: "小孩长大", emoji: "👶", description: "成长的感动瞬间", unlockRequirement: 10, animationName: "child_grow"),
    Scene(name: "月亮升起", emoji: "🌙", description: "宁静浪漫的夜晚", unlockRequirement: 15, animationName: "moon_rise"),
    Scene(name: "咖啡冲泡", emoji: "☕", description: "专注的仪式感", unlockRequirement: 20, animationName: "coffee_brew"),
    Scene(name: "蜡烛燃烧", emoji: "🕯️", description: "温暖的陪伴", unlockRequirement: 25, animationName: "candle_burn"),
    Scene(name: "窗外雨景", emoji: "🌧️", description: "平静治愈的雨天", unlockRequirement: 30, animationName: "rain_window"),
    Scene(name: "书页翻动", emoji: "📚", description: "知识的充实感", unlockRequirement: 35, animationName: "book_flip"),
    Scene(name: "樱花绽放", emoji: "🌸", description: "浪漫的花瓣雨", unlockRequirement: 40, animationName: "sakura_bloom"),
    Scene(name: "篝火燃烧", emoji: "🔥", description: "温暖的团聚", unlockRequirement: 45, animationName: "campfire"),
    Scene(name: "海浪拍岸", emoji: "🌊", description: "辽阔自由的海", unlockRequirement: 50, animationName: "ocean_wave"),
    Scene(name: "向日葵转向", emoji: "🌻", description: "向阳而生", unlockRequirement: 55, animationName: "sunflower"),
    Scene(name: "雪花飘落", emoji: "❄️", description: "纯净的童真", unlockRequirement: 60, animationName: "snow_fall")
]

// Initial unlocked scenes
let initialSceneNames = ["小树生长", "小猫午睡", "小鱼成长"]
