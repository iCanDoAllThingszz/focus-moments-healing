# 专注时光 iOS App 开发任务

## 项目概述
开发一个治愈系专注计时器iOS应用，名为"专注时光（Focus Moments）"。

## 核心功能
1. **场景选择** — 15个治愈场景（初始解锁3个，通过专注次数逐步解锁）
2. **专注计时** — 可选15/25/45/60分钟，全屏沉浸式体验
3. **成就系统** — 星星收集+徽章解锁
4. **日历统计** — 月历视图，显示每日专注记录
5. **数据持久化** — CoreData存储专注记录，UserDefaults存储设置

## 技术要求

### 1. 项目结构
```
FocusMoments/
├── FocusMoments.xcodeproj/          # Xcode项目文件（必须生成）
├── FocusMoments/
│   ├── App/
│   │   ├── FocusMomentsApp.swift    # App入口
│   │   └── ContentView.swift        # 根视图
│   ├── Models/
│   │   ├── Scene.swift              # 场景模型
│   │   ├── FocusSession.swift       # 专注记录模型
│   │   └── Achievement.swift        # 成就模型
│   ├── ViewModels/
│   │   ├── SceneViewModel.swift     # 场景管理
│   │   ├── TimerViewModel.swift     # 计时器逻辑
│   │   └── StatsViewModel.swift     # 统计数据
│   ├── Views/
│   │   ├── Home/
│   │   │   └── HomeView.swift       # 主页（场景选择）
│   │   ├── Timer/
│   │   │   ├── DurationPickerView.swift  # 时长选择
│   │   │   ├── FocusTimerView.swift      # 专注计时页
│   │   │   └── CompletionView.swift      # 完成页
│   │   ├── Calendar/
│   │   │   └── CalendarView.swift   # 日历统计
│   │   ├── Achievement/
│   │   │   └── AchievementView.swift # 成就页
│   │   └── Settings/
│   │       └── SettingsView.swift   # 设置页
│   ├── Services/
│   │   ├── DataManager.swift        # CoreData管理
│   │   └── UserPreferences.swift    # UserDefaults封装
│   ├── Resources/
│   │   ├── Assets.xcassets/         # 图片资源
│   │   └── Animations/              # Lottie动画文件（占位）
│   └── FocusMoments.xcdatamodeld/   # CoreData模型
└── README.md
```

### 2. 架构设计
- **SwiftUI** — 纯SwiftUI实现，iOS 17.0+
- **MVVM** — Model-View-ViewModel架构
- **CoreData** — 专注记录持久化
- **UserDefaults** — 解锁状态、设置项
- **Combine** — 响应式数据流

### 3. 数据模型

#### Scene（场景）
```swift
struct Scene: Identifiable {
    let id: UUID
    let name: String           // 场景名称（如"小树生长"）
    let emoji: String          // 场景图标（如"🌱"）
    let description: String    // 场景描述
    let unlockRequirement: Int // 解锁所需专注次数
    let animationName: String  // Lottie动画文件名
    var isUnlocked: Bool       // 是否已解锁
}
```

#### FocusSession（专注记录）- CoreData
```swift
@objc(FocusSession)
public class FocusSession: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var duration: Int16      // 分钟
    @NSManaged public var sceneName: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
}
```

#### Achievement（成就）
```swift
struct Achievement: Identifiable {
    let id: UUID
    let title: String          // 成就名称
    let description: String    // 成就描述
    let icon: String           // 图标
    let requirement: Int       // 达成条件
    var isUnlocked: Bool       // 是否已解锁
}
```

### 4. 核心功能实现

#### 4.1 场景解锁逻辑
```swift
// 初始解锁3个场景
let initialScenes = ["小树生长", "小猫午睡", "小鱼成长"]

// 解锁规则
func checkUnlock(totalSessions: Int) -> [String] {
    var unlocked: [String] = initialScenes
    if totalSessions >= 5  { unlocked.append("小鸟筑巢") }
    if totalSessions >= 10 { unlocked.append("月亮升起") }
    if totalSessions >= 15 { unlocked.append("咖啡冲泡") }
    // ... 以此类推
    return unlocked
}
```

#### 4.2 计时器实现
```swift
class TimerViewModel: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    
    func start(duration: Int) {
        remainingSeconds = duration * 60
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.complete()
            }
        }
    }
    
    func complete() {
        timer?.invalidate()
        isRunning = false
        // 保存专注记录
        // 触发完成动画
    }
}
```

#### 4.3 数据持久化
```swift
class DataManager: ObservableObject {
    static let shared = DataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FocusMoments")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed: \(error)")
            }
        }
    }
    
    func saveFocusSession(sceneName: String, duration: Int) {
        let context = container.viewContext
        let session = FocusSession(context: context)
        session.id = UUID()
        session.date = Date()
        session.duration = Int16(duration)
        session.sceneName = sceneName
        session.isCompleted = true
        session.createdAt = Date()
        
        try? context.save()
    }
    
    func fetchAllSessions() -> [FocusSession] {
        let request: NSFetchRequest<FocusSession> = FocusSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return (try? container.viewContext.fetch(request)) ?? []
    }
}
```

### 5. UI设计要点

#### 5.1 主页（HomeView）
- 网格布局展示场景卡片
- 已解锁场景：显示emoji+名称，可点击
- 未解锁场景：显示🔒+解锁提示
- 顶部显示星星数量
- 底部显示今日/本周专注次数

#### 5.2 专注页（FocusTimerView）
- 全屏沉浸式
- 中央显示倒计时（可隐藏）
- 背景播放Lottie动画（循环）
- 向下滑动弹窗确认放弃

#### 5.3 完成页（CompletionView）
- 播放完成动画（3-5秒）
- 显示鼓励文字
- 显示获得的星星
- 提示距离下次解锁还差几次
- 按钮：继续专注/休息一下

### 6. 15个场景数据
```swift
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
```

## 开发步骤

### Phase 1: 项目初始化
1. 创建Xcode项目（iOS App, SwiftUI, iOS 17.0+）
2. 配置项目结构（按上述目录结构）
3. 添加CoreData模型文件
4. 配置Info.plist（权限、配置项）

### Phase 2: 数据层
1. 实现Scene模型
2. 实现CoreData模型（FocusSession）
3. 实现DataManager（CoreData管理）
4. 实现UserPreferences（UserDefaults封装）

### Phase 3: ViewModel层
1. SceneViewModel — 场景管理、解锁逻辑
2. TimerViewModel — 计时器逻辑
3. StatsViewModel — 统计数据计算

### Phase 4: View层
1. HomeView — 主页（场景选择）
2. DurationPickerView — 时长选择
3. FocusTimerView — 专注计时页
4. CompletionView — 完成页
5. CalendarView — 日历统计
6. AchievementView — 成就页
7. SettingsView — 设置页

### Phase 5: 集成测试
1. 测试专注流程（选场景→选时长→计时→完成）
2. 测试解锁逻辑
3. 测试数据持久化
4. 测试日历统计

## 注意事项

### ⚠️ 关键约束
1. **必须生成xcodeproj文件** — 不能只有源代码，必须包含完整的Xcode项目配置
2. **新增Swift文件必须更新pbxproj** — 确保所有文件都正确添加到项目中
3. **iOS 17.0+** — 最低支持版本
4. **纯SwiftUI** — 不使用UIKit
5. **MVVM架构** — 严格分离Model/View/ViewModel
6. **Lottie动画** — 先用占位符（彩色矩形），后续替换真实动画

### 🎯 优先级
1. **P0（核心流程）** — 场景选择→时长选择→计时→完成→保存记录
2. **P1（解锁系统）** — 解锁逻辑、星星计算、成就系统
3. **P2（统计功能）** — 日历视图、统计数据
4. **P3（设置功能）** — 设置页、白噪音、勿扰模式

### 📦 依赖库
- **Lottie** — 动画播放（SPM: https://github.com/airbnb/lottie-ios）

## 交付标准
1. ✅ 完整的Xcode项目（包含xcodeproj）
2. ✅ 可以在Xcode中打开并编译通过
3. ✅ 核心流程可以在模拟器中运行
4. ✅ 数据持久化正常工作
5. ✅ 代码结构清晰，符合MVVM架构

## 开始开发
请按照上述要求，使用Claude Code生成完整的iOS项目代码。

**重要：请先创建Xcode项目文件（xcodeproj），然后再添加源代码文件。**
