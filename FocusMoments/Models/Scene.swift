import SwiftUI

struct Scene: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let unlockCount: Int
    let cardGradient: [Color]
    let bgGradient: [Color]
    let accentColor: Color

    static let all: [Scene] = [
        Scene(
            id: "tree",
            name: "小树生长",
            description: "看着小树在专注中慢慢长大",
            unlockCount: 0,
            cardGradient: [Color(hex: "A8E6CF"), Color(hex: "DCEDC1")],
            bgGradient: [Color(hex: "2D6A4F"), Color(hex: "A8E6CF")],
            accentColor: Color(hex: "52B788")
        ),
        Scene(
            id: "cat",
            name: "小猫午睡",
            description: "陪着小猫一起安静地休息",
            unlockCount: 0,
            cardGradient: [Color(hex: "FFD3A5"), Color(hex: "FFA07A")],
            bgGradient: [Color(hex: "E07A5F"), Color(hex: "FFD3A5")],
            accentColor: Color(hex: "F4845F")
        ),
        Scene(
            id: "fish",
            name: "小鱼成长",
            description: "跟小鱼一起在深海中遨游",
            unlockCount: 0,
            cardGradient: [Color(hex: "A8D8EA"), Color(hex: "A0C4FF")],
            bgGradient: [Color(hex: "023E8A"), Color(hex: "48CAE4")],
            accentColor: Color(hex: "0096C7")
        ),
        Scene(
            id: "bird",
            name: "小鸟筑巢",
            description: "看小鸟辛勤地建造温暖的家",
            unlockCount: 5,
            cardGradient: [Color(hex: "B5EAD7"), Color(hex: "FFDAC1")],
            bgGradient: [Color(hex: "AEC6CF"), Color(hex: "FFF0A5")],
            accentColor: Color(hex: "6BAE9C")
        ),
        Scene(
            id: "moon",
            name: "月亮升起",
            description: "在星空下感受宁静的专注",
            unlockCount: 10,
            cardGradient: [Color(hex: "957DAD"), Color(hex: "D291BC")],
            bgGradient: [Color(hex: "03045E"), Color(hex: "480CA8")],
            accentColor: Color(hex: "7B2FBE")
        ),
        Scene(
            id: "flower",
            name: "花朵绽放",
            description: "看花朵在专注中悄然开放",
            unlockCount: 20,
            cardGradient: [Color(hex: "FFB7C5"), Color(hex: "E8B4E8")],
            bgGradient: [Color(hex: "C9184A"), Color(hex: "E8B4E8")],
            accentColor: Color(hex: "FF4D6D")
        ),
        Scene(
            id: "butterfly",
            name: "蝴蝶飞舞",
            description: "蝴蝶翩翩，专注如风",
            unlockCount: 30,
            cardGradient: [Color(hex: "FFEAA7"), Color(hex: "FFB347")],
            bgGradient: [Color(hex: "F9844A"), Color(hex: "FCEABB")],
            accentColor: Color(hex: "F9844A")
        ),
        Scene(
            id: "rainbow",
            name: "彩虹出现",
            description: "雨后彩虹，专注的奖赏",
            unlockCount: 50,
            cardGradient: [Color(hex: "B8E0F7"), Color(hex: "FFFFFF")],
            bgGradient: [Color(hex: "90CAF9"), Color(hex: "E3F2FD")],
            accentColor: Color(hex: "42A5F5")
        ),
        Scene(
            id: "rain",
            name: "雨中咖啡",
            description: "听雨声，静心专注",
            unlockCount: 15,
            cardGradient: [Color(hex:"7FA3C0"), Color(hex:"B8D4E8")],
            bgGradient: [Color(hex:"1A2A3A"), Color(hex:"2D4A6B")],
            accentColor: Color(hex:"5B8FA8")
        ),
        Scene(
            id: "campfire",
            name: "篝火夜晚",
            description: "火光摇曳，温暖专注",
            unlockCount: 25,
            cardGradient: [Color(hex:"FF6B35"), Color(hex:"FF9A3C")],
            bgGradient: [Color(hex:"1A0800"), Color(hex:"3D1A00")],
            accentColor: Color(hex:"FF6B35")
        ),
        Scene(
            id: "snow",
            name: "初雪飘落",
            description: "雪花静静飘落，心如止水",
            unlockCount: 40,
            cardGradient: [Color(hex:"D4EAF7"), Color(hex:"EAF4FB")],
            bgGradient: [Color(hex:"1A2A3A"), Color(hex:"354E66")],
            accentColor: Color(hex:"A8CCE0")
        ),
        Scene(
            id: "aurora",
            name: "极光涌动",
            description: "绚丽极光在夜空中舞动",
            unlockCount: 60,
            cardGradient: [Color(hex:"00B4D8"), Color(hex:"7B2FBE")],
            bgGradient: [Color(hex:"020C1B"), Color(hex:"0A1628")],
            accentColor: Color(hex:"00F5D4")
        ),
        Scene(
            id: "meteor",
            name: "流星许愿",
            description: "许下心愿，专注实现",
            unlockCount: 80,
            cardGradient: [Color(hex:"2D3561"), Color(hex:"A239CA")],
            bgGradient: [Color(hex:"020408"), Color(hex:"0D1B2A")],
            accentColor: Color(hex:"E2C94E")
        ),
        Scene(
            id: "planet",
            name: "星球轨道",
            description: "宇宙运转，万物有序",
            unlockCount: 100,
            cardGradient: [Color(hex:"3A1C71"), Color(hex:"D76D77")],
            bgGradient: [Color(hex:"030308"), Color(hex:"0F0A1E")],
            accentColor: Color(hex:"A78BFA")
        ),
    ]
}
