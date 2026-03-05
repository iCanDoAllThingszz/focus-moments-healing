# FocusMoments（专注时光）设计文档

**日期：** 2026-03-05
**项目：** FocusMoments iOS App
**版本：** v1.0
**状态：** 已批准，待实施

---

## 一、项目概述

治愈系番茄时钟 iOS 应用，目标用户为 18-35 岁年轻用户，核心卖点是高级治愈动效和极简交互体验。

**技术栈：**
- Swift + SwiftUI，iOS 17.0+
- MVVM 架构
- UserDefaults 持久化
- **无第三方依赖**（纯 SwiftUI 动画）

---

## 二、架构设计

### 文件结构

```
FocusMoments/
├── Models/
│   ├── Scene.swift              # 场景数据模型（id, name, emoji, unlockCount, gradient）
│   ├── FocusSession.swift       # 专注会话模型
│   └── UserData.swift           # 用户数据（星星数、今日/本周/总计次数、已解锁场景）
├── ViewModels/
│   ├── HomeViewModel.swift      # 首页逻辑：场景列表、解锁判断、统计数据
│   └── FocusViewModel.swift     # 倒计时逻辑：计时器、完成回调
├── Views/
│   ├── HomeView.swift           # 首页（场景选择 + 统计卡片）
│   ├── DurationPickerView.swift # 时长选择页（预设 + 自定义）
│   ├── FocusView.swift          # 专注倒计时页（全屏沉浸式）
│   ├── CompletionView.swift     # 完成页（星星奖励 + 鼓励文案）
│   └── Components/
│       ├── SceneAnimationView.swift  # 8个场景的 SwiftUI 动画（Canvas + TimelineView）
│       ├── SceneCardView.swift       # 场景卡片（毛玻璃 + 渐变边框）
│       └── UnlockPopupView.swift     # 解锁庆祝弹窗（粒子动效）
├── Services/
│   └── DataManager.swift        # UserDefaults 读写封装
└── Utilities/
    └── Constants.swift          # 颜色、间距、字体等全局常量
```

### 页面导航流

```
HomeView
  └─(点击场景)→ DurationPickerView
                  └─(确认时长)→ FocusView
                                  └─(完成/放弃)→ CompletionView
                                                    └─(返回)→ HomeView
```

---

## 三、数据模型

### Scene.swift

```swift
struct Scene: Identifiable {
    let id: String          // "tree", "cat", "fish"...
    let name: String        // "小树生长"
    let unlockCount: Int    // 解锁所需专注次数（0=默认解锁）
    let gradientColors: [Color]  // 卡片渐变配色
    let backgroundColors: [Color] // 专注页背景渐变
}
```

### UserData（UserDefaults 键值）

| 键 | 类型 | 说明 |
|----|------|------|
| `totalStars` | Int | 累计星星数 |
| `totalSessions` | Int | 总专注次数 |
| `todaySessions` | Int | 今日专注次数 |
| `weekSessions` | Int | 本周专注次数 |
| `lastResetDate` | Date | 今日统计重置日期 |
| `unlockedSceneIds` | [String] | 已解锁场景ID列表 |

---

## 四、UI 视觉设计

### 整体风格

- **背景：** 动态 MeshGradient（奶白→淡紫→淡蓝柔和过渡，缓慢呼吸感）
- **卡片：** `.ultraThinMaterial` 毛玻璃 + 彩色渐变边框（1.5px）
- **圆角：** 24px（卡片）、16px（按钮）
- **阴影：** 柔和多层阴影（颜色取自卡片主色调，opacity 0.15-0.25）
- **字体：** SF Rounded（圆润系统字体）

### 配色方案

| 场景 | 卡片渐变 | 专注页背景 |
|------|---------|-----------|
| 小树生长 | 嫩绿 → 薄荷绿 | 深森林绿 → 嫩绿 |
| 小猫午睡 | 奶橙 → 米白 | 暖橙 → 杏色 |
| 小鱼成长 | 海蓝 → 浅青 | 深海蓝 → 天青 |
| 小鸟筑巢 | 天蓝 → 淡黄 | 晨曦蓝 → 金黄 |
| 月亮升起 | 深蓝 → 紫 | 午夜蓝 → 深紫 |
| 花朵绽放 | 粉红 → 浅紫 | 玫瑰粉 → 薰衣草 |
| 蝴蝶飞舞 | 橙黄 → 珊瑚 | 暖黄 → 橙红 |
| 彩虹出现 | 浅蓝 → 白 | 灰蓝 → 白 |

---

## 五、场景动画设计

全部使用 `TimelineView` + `Canvas` + `Path` + SwiftUI 动画实现，无任何第三方依赖。

| 场景 | 动效实现方案 |
|------|------------|
| 小树生长 | `Path` 绘制分形树枝递归生长，叶片用 `Circle` 粒子群，微风 `sin` 波摇摆 |
| 小猫午睡 | 极简线条猫咪 `Path`，胸腔曲线 `scaleEffect` 呼吸循环，背景光晕 `RadialGradient` 脉动 |
| 小鱼成长 | `Canvas` 绘制流体水面波纹，鱼形 `Path` 沿 `sin` 轨迹游动，`Circle` 气泡粒子上浮 |
| 小鸟筑巢 | 翅膀贝塞尔曲线 `Path` 扑动，飞行弧线轨迹，羽毛粒子 `rotation + offset` |
| 月亮升起 | 月亮 `Circle` 弧线升起，`RadialGradient` 光晕，星点 `Circle` 依次 `opacity` 闪烁 |
| 花朵绽放 | 花瓣 `Path` 旋转展开（6片），颜色 `animatableData` 渐变，落花粒子飘落 |
| 蝴蝶飞舞 | 翅膀 `Path` 对称扑动，`sin+cos` 利萨如轨迹飞行，拖尾粒子 |
| 彩虹出现 | 雨滴线条 `Rectangle` 垂落，彩虹弧线 `trim` 逐段亮起，云朵 `Circle` 组合 |

---

## 六、核心交互细节

### 首页（HomeView）

- 顶部统计卡片：今日 / 本周 / 总计 / 星星，毛玻璃样式
- 推荐场景大卡片（全宽，高度 220px）
- 已解锁场景 2列网格（高度 160px）
- 未解锁场景 2列网格（高度 140px，毛玻璃遮罩 + 锁图标 + "需N次专注"）
- 卡片点击：`scaleEffect(0.95)` 弹簧动画 + `impactOccurred()` 触觉反馈

### 时长选择页（DurationPickerView）

- 场景动画小预览（120px）
- 预设时长圆形按钮：15 / 25 / 45 / 60 分钟
- 自定义时长：`Stepper` 或 滑动选择器（1-120分钟）
- 开始按钮：全宽，场景主色渐变背景

### 专注页（FocusView）

- 全屏沉浸式，场景背景渐变
- 场景动画全屏展示（占据 60% 高度）
- 倒计时大字体悬浮（SF Rounded，80px）
- 进度环绕计时器
- 底部"放弃"小按钮（需二次确认）

### 完成页（CompletionView）

- 星星掉落粒子动画
- 鼓励文案（随机5条）
- 获得 +1 星星展示
- 解锁提示（若达到解锁条件，自动弹出 `UnlockPopupView`）

### 解锁弹窗（UnlockPopupView）

- 全屏半透明遮罩
- 中心卡片：场景动画预览 + 解锁文案
- 五彩纸屑粒子动效
- "太棒了！" 确认按钮

---

## 七、8个场景定义

| ID | 名称 | 解锁条件 | 卡片渐变色 |
|----|------|---------|-----------|
| tree | 小树生长 | 默认解锁 | #A8E6CF → #DCEDC1 |
| cat | 小猫午睡 | 默认解锁 | #FFD3A5 → #FFA07A |
| fish | 小鱼成长 | 默认解锁 | #A8D8EA → #A0C4FF |
| bird | 小鸟筑巢 | 5次专注 | #B5EAD7 → #FFDAC1 |
| moon | 月亮升起 | 10次专注 | #957DAD → #D291BC |
| flower | 花朵绽放 | 20次专注 | #FFB7C5 → #E8B4E8 |
| butterfly | 蝴蝶飞舞 | 30次专注 | #FFEAA7 → #FFB347 |
| rainbow | 彩虹出现 | 50次专注 | #B8E0F7 → #FFFFFF |

---

## 八、数据流

```
完成专注
  → FocusViewModel.completeSession()
  → DataManager.recordSession()
    → 更新 totalStars, totalSessions, todaySessions, weekSessions
    → 检查并更新 unlockedSceneIds
  → HomeViewModel.refresh()
    → 重新加载场景解锁状态
    → 判断是否触发解锁弹窗
  → UI 更新
```

---

## 九、验收标准

- [ ] 4个页面完整实现，导航流程正确
- [ ] 8个场景动画流畅播放（>30fps）
- [ ] 渐进解锁机制正常工作
- [ ] 数据持久化（杀死 App 重启后数据保留）
- [ ] 首次启动默认解锁 tree/cat/fish 三个场景
- [ ] 解锁弹窗在达成条件后正确触发
- [ ] iOS 17.0+ 编译通过，无 Warning
- [ ] 内存占用 < 100MB

---

*设计已由用户批准，2026-03-05*
