# 专注时光 (Focus Moments) - iOS App

## 项目状态

✅ **完整的iOS项目已生成** - 可以直接在Xcode中打开并编译

## 项目结构

```
FocusMoments/
├── FocusMoments.xcodeproj/           # ✅ Xcode项目文件（可直接打开）
├── FocusMoments/
│   ├── App/
│   │   ├── FocusMomentsApp.swift     # App入口
│   │   └── ContentView.swift          # 根视图
│   ├── Models/
│   │   ├── Scene.swift                # 15个场景模型
│   │   └── Achievement.swift          # 成就模型
│   ├── ViewModels/
│   │   ├── SceneViewModel.swift       # 场景管理+解锁逻辑
│   │   ├── TimerViewModel.swift       # 计时器逻辑
│   │   └── StatsViewModel.swift       # 统计数据
│   ├── Views/
│   │   ├── Home/HomeView.swift        # 主页（场景选择）
│   │   ├── Timer/
│   │   │   ├── DurationPickerView.swift   # 时长选择
│   │   │   ├── FocusTimerView.swift       # 专注计时页
│   │   │   └── CompletionView.swift       # 完成页
│   │   ├── Calendar/CalendarView.swift    # 日历统计
│   │   ├── Achievement/AchievementView.swift # 成就页
│   │   └── Settings/SettingsView.swift    # 设置页
│   ├── Services/
│   │   ├── DataManager.swift          # CoreData管理
│   │   └── UserPreferences.swift     # UserDefaults封装
│   ├── Resources/
│   │   └── Assets.xcassets/           # 资源文件
│   ├── FocusMoments.xcdatamodeld/    # CoreData模型
│   ├── Info.plist
│   └── FocusMoments.entitlements
└── project.yml                        # xcodegen配置
```

## 核心功能

### 1. 15个治愈场景 🌱😺🐠🐦👶🌙☕🕯️🌧️📚🌸🔥🌊🌻❄️
- 初始解锁3个：小树生长、小猫午睡、小鱼成长
- 通过专注次数逐步解锁（5次、10次、15次...）
- 每个场景都有独特的emoji和描述

### 2. 专注计时器 ⏱️
- 支持4种时长：15/25/45/60分钟
- 全屏沉浸式体验
- 后台计时支持（锁屏后继续计时）
- 可暂停/恢复/取消

### 3. 星星收集系统 ⭐
- 完成专注获得星星
- 星星数量 = 专注时长（分钟）
- 用于解锁新场景和成就

### 4. 成就系统 🏆
- 12个成就可解锁：
  - 初心者（完成第1次）
  - 专注新手（10次）
  - 专注达人（50次）
  - 专注大师（100次）
  - 连续专注（连续7天）
  - 深度专注（单次60分钟）
  - 全场景收集（解锁全部15个）
  - 早起专注（6-8点）
  - 深夜专注（10-12点）
  - 等等...

### 5. 日历统计 📅
- 月历视图，显示每日专注记录
- 统计数据：本月专注次数、总时长、最长连续天数
- 点击某天查看详情

### 6. 数据持久化 💾
- CoreData存储专注记录
- UserDefaults存储设置和解锁状态
- 数据不会丢失

## 技术栈

- **语言**: Swift
- **框架**: SwiftUI
- **架构**: MVVM
- **最低版本**: iOS 17.0+
- **数据库**: CoreData
- **动画**: Lottie（需要手动添加依赖）

## 如何运行

### 1. 在Mac上打开项目

```bash
# 方式1：双击打开
open FocusMoments.xcodeproj

# 方式2：命令行打开
cd /path/to/focus-moments-ios-rebuild
xed .
```

### 2. 添加Lottie依赖（可选）

当前版本使用占位符动画（彩色矩形）。如果要使用真实的Lottie动画：

1. 在Xcode中选择项目 → FocusMoments target
2. 选择 "Package Dependencies" 标签
3. 点击 "+" 添加依赖
4. 输入URL: `https://github.com/airbnb/lottie-ios`
5. 选择版本（推荐最新版本）
6. 点击 "Add Package"

### 3. 选择模拟器或真机

- 推荐：iPhone 15 Pro 模拟器
- 或连接真机（需要Apple Developer账号）

### 4. 编译并运行

- 快捷键：`Cmd + R`
- 或点击左上角的 ▶️ 按钮

## 当前状态

### ✅ 已完成
- [x] 完整的项目结构
- [x] MVVM架构
- [x] 15个场景数据
- [x] 场景解锁逻辑
- [x] 计时器功能（包括后台计时）
- [x] 星星收集系统
- [x] 成就系统
- [x] CoreData数据持久化
- [x] 日历统计视图
- [x] 设置页面
- [x] 所有UI页面（Home/Timer/Calendar/Achievement/Settings）

### ⚠️ 待完善
- [ ] Lottie动画集成（需要手动添加SPM依赖）
- [ ] 真实的Lottie动画文件（当前是占位符）
- [ ] 白噪音功能（需要音频文件）
- [ ] 勿扰模式集成
- [ ] App图标和启动页
- [ ] 内购功能（解锁全部场景）

### 🎨 设计资源需求
- [ ] 15个场景的Lottie动画文件（JSON格式）
- [ ] App图标（1024x1024）
- [ ] 启动页设计
- [ ] 白噪音音频文件（雨声/森林/海浪）

## 下一步

### 方案A：直接测试（推荐）
1. 在Xcode中打开项目
2. 编译并运行
3. 测试核心流程：选场景 → 选时长 → 计时 → 完成
4. 验证数据持久化（关闭App重新打开，数据还在）

### 方案B：添加真实动画
1. 添加Lottie依赖（见上文）
2. 准备15个Lottie动画JSON文件
3. 放入 `FocusMoments/Resources/Animations/` 目录
4. 更新代码中的动画文件名

### 方案C：完善功能
1. 添加白噪音音频文件
2. 实现勿扰模式
3. 设计App图标和启动页
4. 添加内购功能

## 注意事项

1. **Xcode版本**: 需要Xcode 15.0+（支持iOS 17.0+）
2. **Mac系统**: macOS 13.0+
3. **模拟器**: 推荐iPhone 15 Pro或更新机型
4. **真机测试**: 需要Apple Developer账号（免费账号也可以，但有限制）

## 问题排查

### 编译错误
- 确保Xcode版本 >= 15.0
- 确保选择了正确的target（FocusMoments）
- 清理构建缓存：`Cmd + Shift + K`

### 运行时错误
- 检查模拟器版本（iOS 17.0+）
- 查看Xcode控制台的错误信息
- 确保CoreData模型文件正确加载

### 数据不持久化
- 检查DataManager是否正确初始化
- 查看CoreData错误日志
- 尝试删除App重新安装

## 联系方式

如有问题，随时找我！我会帮你解决～

---

**生成时间**: 2026-03-03  
**生成工具**: Claude Code (MiniMax-M2.5)  
**架构**: MVVM + SwiftUI + CoreData
