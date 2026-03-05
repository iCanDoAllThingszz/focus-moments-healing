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
        )
    ]
}
