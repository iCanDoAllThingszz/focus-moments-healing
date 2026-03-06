# UI Redesign & Scene Expansion Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Dual-theme HomeView (Dark Glass / Soft Orb, long-press switch), progress-aware scene animations that evolve during focus sessions, 6 new scenes, and functional verification.

**Architecture:** Theme stored in DataManager via UserDefaults. SceneAnimationView gains `progress: Double` + `celebrating: Bool` params. FocusView passes live progress. All 14 scenes have seedling→full evolution. CompletionView plays celebrating burst.

**Tech Stack:** Swift 5.9, SwiftUI, iOS 17+, Canvas+TimelineView for animations, @Observable, UserDefaults

---

### Task 1: DataManager — add themeStyle

**Files:**
- Modify: `FocusMoments/Services/DataManager.swift`

**Step 1: Add themeStyle property**

```swift
var themeStyle: String {
    get { defaults.string(forKey: "themeStyle") ?? "softOrb" }
    set { defaults.set(newValue, forKey: "themeStyle") }
}
```

Add after `unlockedSceneIds` property.

**Step 2: Build check**
Git pull on Mac → Cmd+B in Xcode. Should compile cleanly.

**Step 3: Commit**
```bash
git add FocusMoments/Services/DataManager.swift
git commit -m "feat: add themeStyle to DataManager"
```

---

### Task 2: Scene.swift — add 6 new scenes

**Files:**
- Modify: `FocusMoments/Models/Scene.swift`

**Step 1: Append 6 scenes to `Scene.all` array**

```swift
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
```

**Step 2: Commit**
```bash
git add FocusMoments/Models/Scene.swift
git commit -m "feat: add 6 new scenes (rain, campfire, snow, aurora, meteor, planet)"
```

---

### Task 3: SceneAnimationView — update router interface

**Files:**
- Modify: `FocusMoments/Views/Components/SceneAnimationView.swift` (top ~20 lines)

**Step 1: Update SceneAnimationView struct and router**

Replace the existing `SceneAnimationView` struct and its `body`:

```swift
struct SceneAnimationView: View {
    let sceneId: String
    var size: CGFloat = 200
    var progress: Double = 0      // 0.0 (start) → 1.0 (complete)
    var celebrating: Bool = false  // true = play burst animation

    var body: some View {
        switch sceneId {
        case "tree":       TreeAnimation(size: size, progress: progress, celebrating: celebrating)
        case "cat":        CatAnimation(size: size, progress: progress, celebrating: celebrating)
        case "fish":       FishAnimation(size: size, progress: progress, celebrating: celebrating)
        case "bird":       BirdAnimation(size: size, progress: progress, celebrating: celebrating)
        case "moon":       MoonAnimation(size: size, progress: progress, celebrating: celebrating)
        case "flower":     FlowerAnimation(size: size, progress: progress, celebrating: celebrating)
        case "butterfly":  ButterflyAnimation(size: size, progress: progress, celebrating: celebrating)
        case "rainbow":    RainbowAnimation(size: size, progress: progress, celebrating: celebrating)
        case "rain":       RainAnimation(size: size, progress: progress, celebrating: celebrating)
        case "campfire":   CampfireAnimation(size: size, progress: progress, celebrating: celebrating)
        case "snow":       SnowAnimation(size: size, progress: progress, celebrating: celebrating)
        case "aurora":     AuroraAnimation(size: size, progress: progress, celebrating: celebrating)
        case "meteor":     MeteorAnimation(size: size, progress: progress, celebrating: celebrating)
        case "planet":     PlanetAnimation(size: size, progress: progress, celebrating: celebrating)
        default:           TreeAnimation(size: size, progress: progress, celebrating: celebrating)
        }
    }
}
```

**Step 2: Commit**
```bash
git add FocusMoments/Views/Components/SceneAnimationView.swift
git commit -m "feat: add progress+celebrating params to SceneAnimationView router"
```

---

### Task 4: Update all 8 existing animations for progress-awareness

**Files:**
- Modify: `FocusMoments/Views/Components/SceneAnimationView.swift`

Update each animation struct signature and behavior. Here is the complete updated code for all 8:

#### TreeAnimation
```swift
struct TreeAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let sway = sin(t * 0.8) * 0.06
                // progress drives depth: 2 → 7
                let depth = Int(2 + progress * 5)
                let trunkH = sz.height * (0.15 + CGFloat(progress) * 0.25)
                drawBranch(ctx: ctx, sz: sz,
                           x: sz.width/2, y: sz.height * 0.9,
                           angle: -.pi/2, length: trunkH,
                           depth: depth, sway: sway, t: t, progress: progress)
                // Celebration: falling golden leaves
                if celebrating {
                    for i in 0..<40 {
                        let seed = Double(i * 137)
                        let lx = sz.width * (seed * 0.618).truncatingRemainder(dividingBy: 1.0)
                        let ly = sz.height * fmod((seed * 0.382) + t * 0.4, 1.0)
                        let leafR: CGFloat = 4
                        ctx.fill(Path(ellipseIn: CGRect(x:lx-leafR, y:ly-leafR, width:leafR*2, height:leafR*2)),
                                 with: .color(Color(hex:"FFD700").opacity(0.85)))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }

    func drawBranch(ctx: GraphicsContext, sz: CGSize, x: CGFloat, y: CGFloat,
                    angle: CGFloat, length: CGFloat, depth: Int, sway: CGFloat, t: Double, progress: Double) {
        guard depth > 0, length > 2 else { return }
        let endX = x + cos(angle + sway * CGFloat(depth)) * length
        let endY = y + sin(angle + sway * CGFloat(depth)) * length
        var path = Path()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: endX, y: endY))
        let w = CGFloat(depth) * 0.8
        let brown = Color(red: 0.4, green: 0.25, blue: 0.1)
        ctx.stroke(path, with: .color(depth > 3 ? brown : Color(red:0.3,green:0.5,blue:0.2)),
                   lineWidth: max(w, 0.5))
        if depth <= 2 {
            let leafR = length * 0.9
            let leafAlpha = CGFloat(progress) * (0.5 + 0.5 * sin(t * 1.2 + Double(depth)))
            let leafRect = CGRect(x: endX-leafR/2, y: endY-leafR/2, width: leafR, height: leafR)
            ctx.fill(Path(ellipseIn: leafRect),
                     with: .color(Color(red:0.2,green:0.7,blue:0.3).opacity(leafAlpha)))
        }
        let spread: CGFloat = .pi / 5
        drawBranch(ctx: ctx, sz: sz, x: endX, y: endY, angle: angle - spread,
                   length: length * 0.68, depth: depth-1, sway: sway, t: t, progress: progress)
        drawBranch(ctx: ctx, sz: sz, x: endX, y: endY, angle: angle + spread,
                   length: length * 0.68, depth: depth-1, sway: sway, t: t, progress: progress)
    }
}
```

#### CatAnimation
Add params to struct, use `progress` to deepen sleep:
```swift
struct CatAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false
    @State private var breathScale: CGFloat = 1.0
    @State private var tailCurl: CGFloat = 0.3
    // ... (body same as before, but add celebrating hearts overlay)
    // In ZStack, add:
    // if celebrating { HeartBurstOverlay() }
}
```

For brevity, add these two lines at bottom of CatAnimation ZStack:
```swift
// heart burst on celebration
if celebrating {
    ForEach(0..<8, id: \.self) { i in
        Text("❤️").font(.caption)
            .offset(x: CGFloat.random(in: -50...50),
                    y: CGFloat.random(in: -80...(-20)))
            .opacity(celebrating ? 1 : 0)
    }
}
```

#### FlowerAnimation
Use `progress` to drive bloom instead of onAppear spring:
```swift
struct FlowerAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false
    // Remove @State private var bloom — drive from progress directly
    // In body: let bloom = CGFloat(progress)
    // For celebrating: scatter petals (rotation speed * 3)
}
```

Replace `@State private var bloom: CGFloat = 0` with `var bloom: CGFloat { CGFloat(progress) }` and remove the `.onAppear` bloom animation.

#### MoonAnimation
Use `progress` instead of `t/4.0` for rise:
```swift
// Replace: let riseProgress = min(1.0, t / 4.0)
// With:
let riseProgress = CGFloat(progress) + CGFloat(min(1.0, t.truncatingRemainder(dividingBy: 0.1)) * 0.02)
// i.e. moon height locked to focus progress, with tiny shimmer
let moonY = sz.height * (0.9 - CGFloat(progress) * 0.6)
```

#### RainbowAnimation
Use `progress` for arc reveal:
```swift
// Replace: let showProgress = min(1.0, max(0.0, t / 5.0))
// With:
let showProgress = progress
```

#### ButterflyAnimation
Scale butterfly count with progress:
```swift
// Add to Canvas body:
let butterflyCount = max(1, Int(progress * 3) + 1) // 1 → 3
for bIdx in 0..<butterflyCount { ... }
```

#### BirdAnimation & FishAnimation
Add the same `progress` + `celebrating` params (structural change only — pass through for now, no visual change needed since their idle animations are already meaningful).

**Step 1: Apply all changes above to SceneAnimationView.swift**

**Step 2: Build check** — Cmd+B

**Step 3: Commit**
```bash
git add FocusMoments/Views/Components/SceneAnimationView.swift
git commit -m "feat: progress-aware animations for all 8 existing scenes"
```

---

### Task 5: Add 6 new animations

**Files:**
- Modify: `FocusMoments/Views/Components/SceneAnimationView.swift` (append at bottom)

#### RainAnimation
```swift
struct RainAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let intensity = CGFloat(0.3 + progress * 0.7) // light → heavy
                let dropCount = Int(20 + progress * 60)

                // rain drops
                for i in 0..<dropCount {
                    let rx = sz.width * CGFloat(i) / CGFloat(dropCount) + CGFloat(i % 4) * 8
                    let ry = fmod(CGFloat(t) * (150 + intensity * 100) + CGFloat(i * 27), sz.height)
                    let len = 8 + intensity * 8
                    var drop = Path()
                    drop.move(to: CGPoint(x: rx, y: ry))
                    drop.addLine(to: CGPoint(x: rx - 2, y: ry + len))
                    ctx.stroke(drop, with: .color(Color(hex:"7EC8E3").opacity(Double(0.4 + intensity * 0.3))), lineWidth: 1)
                }

                // window glass effect — subtle reflection lines
                for i in 0..<3 {
                    let gx = sz.width * CGFloat([0.2, 0.5, 0.75][i])
                    var glare = Path()
                    glare.move(to: CGPoint(x: gx, y: 0))
                    glare.addLine(to: CGPoint(x: gx + 10, y: sz.height))
                    ctx.stroke(glare, with: .color(Color.white.opacity(0.06)), lineWidth: 2)
                }

                // celebration: rainbow appears
                if celebrating {
                    let center = CGPoint(x: sz.width/2, y: sz.height*0.8)
                    let colors: [Color] = [.red,.orange,.yellow,.green,.blue,.purple]
                    for (idx, color) in colors.enumerated() {
                        let r = sz.width * (0.15 + CGFloat(idx) * 0.04)
                        var arc = Path()
                        arc.addArc(center: center, radius: r, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
                        ctx.stroke(arc, with: .color(color.opacity(0.8)), lineWidth: 4)
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

#### CampfireAnimation
```swift
struct CampfireAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let intensity = CGFloat(0.4 + progress * 0.6)
                let cx = sz.width / 2
                let base = sz.height * 0.75

                // logs
                for side: CGFloat in [-1, 1] {
                    var log = Path()
                    log.move(to: CGPoint(x: cx + side*sz.width*0.18, y: base+8))
                    log.addLine(to: CGPoint(x: cx - side*sz.width*0.05, y: base))
                    ctx.stroke(log, with: .color(Color(hex:"5C3317")), lineWidth: 6)
                }

                // flame layers (3 bezier flames)
                let flameH = sz.height * (0.18 + intensity * 0.15)
                let flicker = CGFloat(sin(t * 7)) * 0.15
                for layer in 0..<3 {
                    let layerScale = CGFloat(1.0 - Double(layer) * 0.25)
                    let colors: [Color] = [Color(hex:"FF4500"), Color(hex:"FF8C00"), Color(hex:"FFD700")]
                    var flame = Path()
                    let fw = sz.width * 0.12 * layerScale * intensity
                    flame.move(to: CGPoint(x: cx, y: base))
                    flame.addCurve(
                        to: CGPoint(x: cx, y: base - flameH * layerScale),
                        control1: CGPoint(x: cx - fw, y: base - flameH * 0.4 * layerScale),
                        control2: CGPoint(x: cx - fw * (0.5 + flicker), y: base - flameH * 0.8 * layerScale)
                    )
                    flame.addCurve(
                        to: CGPoint(x: cx, y: base),
                        control1: CGPoint(x: cx + fw * (0.5 - flicker), y: base - flameH * 0.8 * layerScale),
                        control2: CGPoint(x: cx + fw, y: base - flameH * 0.4 * layerScale)
                    )
                    ctx.fill(flame, with: .color(colors[layer].opacity(Double(0.7 * layerScale))))
                }

                // embers / sparks
                let sparkCount = Int(8 + progress * 20)
                for i in 0..<sparkCount {
                    let seed = Double(i * 71)
                    let sx = cx + CGFloat(sin(seed + t * 2)) * sz.width * 0.1
                    let sy = base - fmod(CGFloat(t * 80 + seed * 40), sz.height * 0.7)
                    let sr: CGFloat = 1.5
                    ctx.fill(Path(ellipseIn: CGRect(x:sx-sr, y:sy-sr, width:sr*2, height:sr*2)),
                             with: .color(Color(hex:"FFA500").opacity(Double(0.8 - sy/sz.height))))
                }

                // celebration: spark explosion
                if celebrating {
                    for i in 0..<30 {
                        let angle = Double(i) / 30 * .pi * 2
                        let dist = sz.width * 0.3 * CGFloat(fmod(t, 1.0))
                        let px = cx + cos(angle) * dist
                        let py = base + sin(angle) * dist * 0.5
                        ctx.fill(Path(ellipseIn: CGRect(x:px-3, y:py-3, width:6, height:6)),
                                 with: .color(Color(hex:"FFD700").opacity(max(0, 1 - fmod(t,1.0)))))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

#### SnowAnimation
```swift
struct SnowAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let flakeCount = Int(20 + progress * 80)

                // ground snow accumulation
                let groundH = sz.height * CGFloat(progress) * 0.15
                let groundRect = CGRect(x: 0, y: sz.height - groundH, width: sz.width, height: groundH)
                ctx.fill(Path(roundedRect: groundRect, cornerRadius: 0),
                         with: .color(Color.white.opacity(0.6)))

                // snowflakes
                for i in 0..<flakeCount {
                    let seed = Double(i * 113)
                    let fx = sz.width * ((seed * 0.618).truncatingRemainder(dividingBy: 1.0))
                    let speed = 40.0 + (seed.truncatingRemainder(dividingBy: 30))
                    let fy = fmod(CGFloat(t) * CGFloat(speed) + CGFloat(seed * 20), sz.height)
                    let drift = sin(t * 0.5 + seed) * 8
                    let fr: CGFloat = CGFloat(1.5 + (seed.truncatingRemainder(dividingBy: 3)))
                    ctx.fill(Path(ellipseIn: CGRect(x: fx+drift-fr, y: fy-fr, width: fr*2, height: fr*2)),
                             with: .color(Color.white.opacity(0.85)))
                }

                // celebration: snowflake mandala burst
                if celebrating {
                    let cx = sz.width/2, cy = sz.height/2
                    for i in 0..<12 {
                        let angle = Double(i) / 12 * .pi * 2
                        let dist = sz.width * 0.3 * CGFloat(fmod(t, 1.5) / 1.5)
                        let px = cx + cos(angle) * dist
                        let py = cy + sin(angle) * dist
                        ctx.fill(Path(ellipseIn: CGRect(x:px-4, y:py-4, width:8, height:8)),
                                 with: .color(Color.white.opacity(max(0, 1 - fmod(t,1.5)/1.5))))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

#### AuroraAnimation
```swift
struct AuroraAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let bandCount = Int(2 + progress * 4) // 2 → 6 bands

                let auroraColors: [Color] = [
                    Color(hex:"00F5D4"), Color(hex:"7B2FBE"),
                    Color(hex:"00B4D8"), Color(hex:"48CAE4"),
                    Color(hex:"A9FF96"), Color(hex:"FF6B9D")
                ]

                for band in 0..<bandCount {
                    let colorIdx = band % auroraColors.count
                    let phase = Double(band) * 0.8
                    let yBase = sz.height * CGFloat(0.2 + Double(band) * 0.12)
                    let amplitude = sz.height * CGFloat(0.06 + progress * 0.04)
                    let alpha = 0.3 + progress * 0.4

                    var wavePath = Path()
                    wavePath.move(to: CGPoint(x: 0, y: sz.height))
                    for x in stride(from: 0.0, through: Double(sz.width), by: 3.0) {
                        let y = yBase + amplitude * CGFloat(sin(x * 0.015 + t * 0.8 + phase))
                        wavePath.addLine(to: CGPoint(x: x, y: y))
                    }
                    wavePath.addLine(to: CGPoint(x: sz.width, y: sz.height))
                    wavePath.closeSubpath()
                    ctx.fill(wavePath, with: .color(auroraColors[colorIdx].opacity(alpha)))
                }

                // stars
                for i in 0..<30 {
                    let seed = Double(i * 97)
                    let sx = sz.width * ((seed * 0.618).truncatingRemainder(dividingBy: 1.0))
                    let sy = sz.height * 0.3 * ((seed * 0.382).truncatingRemainder(dividingBy: 1.0))
                    let alpha = 0.4 + 0.6 * sin(t * 1.5 + seed)
                    ctx.fill(Path(ellipseIn: CGRect(x:sx-1, y:sy-1, width:2, height:2)),
                             with: .color(Color.white.opacity(alpha)))
                }

                // celebration: aurora nova
                if celebrating {
                    for i in 0..<6 {
                        let color = auroraColors[i]
                        let r = sz.width * CGFloat(0.1 + Double(i) * 0.06 + fmod(t, 1.0) * 0.2)
                        let cx = sz.width/2, cy = sz.height/2
                        ctx.stroke(Path(ellipseIn: CGRect(x:cx-r, y:cy-r, width:r*2, height:r*2)),
                                   with: .color(color.opacity(max(0, 1 - fmod(t,1.0)))), lineWidth: 2)
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

#### MeteorAnimation
```swift
struct MeteorAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let meteorCount = Int(1 + progress * 4) // 1 → 5

                // stars
                for i in 0..<50 {
                    let seed = Double(i * 137)
                    let sx = sz.width * ((seed * 0.618).truncatingRemainder(dividingBy: 1.0))
                    let sy = sz.height * ((seed * 0.382).truncatingRemainder(dividingBy: 1.0))
                    let alpha = 0.3 + 0.7 * sin(t + seed)
                    let r: CGFloat = seed.truncatingRemainder(dividingBy: 3) < 1 ? 1.5 : 0.8
                    ctx.fill(Path(ellipseIn: CGRect(x:sx-r, y:sy-r, width:r*2, height:r*2)),
                             with: .color(Color.white.opacity(alpha)))
                }

                // meteors
                for i in 0..<meteorCount {
                    let seed = Double(i * 53 + 17)
                    let cycle = fmod(t * 0.4 + seed * 0.3, 1.0)
                    let startX = sz.width * CGFloat((seed * 0.4).truncatingRemainder(dividingBy: 1.0))
                    let mx = startX + sz.width * CGFloat(cycle) * 0.6
                    let my = sz.height * CGFloat(cycle) * 0.5
                    let tailLen: CGFloat = 40 + CGFloat(progress) * 30
                    var meteor = Path()
                    meteor.move(to: CGPoint(x: mx, y: my))
                    meteor.addLine(to: CGPoint(x: mx - tailLen, y: my - tailLen * 0.5))
                    ctx.stroke(meteor,
                               with: .linearGradient(Gradient(colors:[Color(hex:"E2C94E"), .clear]),
                                                     startPoint: CGPoint(x:mx, y:my),
                                                     endPoint: CGPoint(x:mx-tailLen, y:my-tailLen*0.5)),
                               lineWidth: 1.5)
                }

                // celebration: meteor burst
                if celebrating {
                    for i in 0..<20 {
                        let angle = Double(i) / 20 * .pi * 2
                        let dist = sz.width * 0.35 * CGFloat(fmod(t, 1.2) / 1.2)
                        let px = sz.width/2 + cos(angle) * dist
                        let py = sz.height/2 + sin(angle) * dist
                        ctx.fill(Path(ellipseIn: CGRect(x:px-2, y:py-2, width:4, height:4)),
                                 with: .color(Color(hex:"E2C94E").opacity(max(0, 1 - fmod(t,1.2)/1.2))))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

#### PlanetAnimation
```swift
struct PlanetAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    struct PlanetDef {
        let color: Color
        let orbitR: CGFloat
        let radius: CGFloat
        let speed: Double
        let hasRing: Bool
    }

    let planets: [PlanetDef] = [
        PlanetDef(color: Color(hex:"C8A882"), orbitR: 0.22, radius: 10, speed: 0.5, hasRing: false),
        PlanetDef(color: Color(hex:"E8B4B8"), orbitR: 0.35, radius: 14, speed: 0.3, hasRing: true),
        PlanetDef(color: Color(hex:"A78BFA"), orbitR: 0.46, radius: 10, speed: 0.18, hasRing: false),
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let cx = sz.width/2, cy = sz.height/2
                let visibleCount = max(1, Int(progress * 3) + 1) // 1 → 3

                // stars
                for i in 0..<40 {
                    let seed = Double(i * 97)
                    let sx = sz.width * ((seed*0.618).truncatingRemainder(dividingBy:1))
                    let sy = sz.height * ((seed*0.382).truncatingRemainder(dividingBy:1))
                    let alpha = 0.3 + 0.5 * sin(t + seed)
                    ctx.fill(Path(ellipseIn: CGRect(x:sx-1,y:sy-1,width:2,height:2)),
                             with: .color(Color.white.opacity(alpha)))
                }

                // sun
                let sunR: CGFloat = 16
                ctx.fill(Path(ellipseIn: CGRect(x:cx-sunR, y:cy-sunR, width:sunR*2, height:sunR*2)),
                         with: .color(Color(hex:"FFF176")))

                // planets
                for (i, planet) in planets.prefix(visibleCount).enumerated() {
                    let orbitR = sz.width * planet.orbitR
                    // orbit ring
                    ctx.stroke(Path(ellipseIn: CGRect(x:cx-orbitR, y:cy-orbitR*0.4,
                                                      width:orbitR*2, height:orbitR*0.8)),
                               with: .color(Color.white.opacity(0.12)), lineWidth: 1)
                    // planet position
                    let angle = t * planet.speed + Double(i) * 2.1
                    let px = cx + cos(angle) * orbitR
                    let py = cy + sin(angle) * orbitR * 0.4
                    // ring (behind planet if on far side)
                    if planet.hasRing && sin(angle) < 0 {
                        let rw = planet.radius * 2.2
                        ctx.stroke(Path(ellipseIn: CGRect(x:px-rw, y:py-planet.radius*0.3,
                                                          width:rw*2, height:planet.radius*0.6)),
                                   with: .color(Color(hex:"D4B896").opacity(0.7)), lineWidth: 3)
                    }
                    ctx.fill(Path(ellipseIn: CGRect(x:px-planet.radius, y:py-planet.radius,
                                                    width:planet.radius*2, height:planet.radius*2)),
                             with: .color(planet.color))
                    if planet.hasRing && sin(angle) >= 0 {
                        let rw = planet.radius * 2.2
                        ctx.stroke(Path(ellipseIn: CGRect(x:px-rw, y:py-planet.radius*0.3,
                                                          width:rw*2, height:planet.radius*0.6)),
                                   with: .color(Color(hex:"D4B896").opacity(0.7)), lineWidth: 3)
                    }
                }

                // celebration: orbital fireworks
                if celebrating {
                    for i in 0..<24 {
                        let angle = Double(i) / 24 * .pi * 2
                        let dist = sz.width * 0.4 * CGFloat(fmod(t, 1.0))
                        let px = cx + cos(angle) * dist
                        let py = cy + sin(angle) * dist * 0.5
                        ctx.fill(Path(ellipseIn: CGRect(x:px-3,y:py-3,width:6,height:6)),
                                 with: .color(Color(hex:"A78BFA").opacity(max(0, 1-fmod(t,1.0)))))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}
```

**Step 1: Append all 6 animations to SceneAnimationView.swift**

**Step 2: Build check** — Cmd+B. All 14 animations should compile.

**Step 3: Commit**
```bash
git add FocusMoments/Views/Components/SceneAnimationView.swift
git commit -m "feat: add 6 new scene animations (rain, campfire, snow, aurora, meteor, planet)"
```

---

### Task 6: HomeView — dual-theme + orb background + long-press switch

**Files:**
- Modify: `FocusMoments/Views/HomeView.swift`

**Step 1: Replace HomeView.swift completely**

```swift
import SwiftUI

struct HomeView: View {
    @State private var homeVM = HomeViewModel()
    @State private var path = NavigationPath()

    var isDark: Bool { DataManager.shared.themeStyle == "darkGlass" }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // --- Background ---
                if isDark {
                    DarkGlassBackground()
                } else {
                    SoftOrbBackground()
                }

                ScrollView {
                    VStack(spacing: AppConstants.Spacing.lg) {
                        // Header
                        HomeHeaderView(isDark: isDark)
                            .padding(.horizontal, AppConstants.Spacing.md)
                            .padding(.top, AppConstants.Spacing.sm)

                        // Stats
                        StatsRowView(homeVM: homeVM, isDark: isDark)
                            .padding(.horizontal, AppConstants.Spacing.md)

                        // Featured
                        SectionLabel("精选场景", isDark: isDark)
                        SceneCardView(scene: homeVM.featuredScene, size: .featured, isDark: isDark) {
                            path.append(homeVM.featuredScene)
                        }
                        .padding(.horizontal, AppConstants.Spacing.md)

                        // Unlocked
                        if homeVM.unlockedScenes.count > 1 {
                            SectionLabel("已解锁", isDark: isDark)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                      spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.unlockedScenes.filter { $0.id != homeVM.featuredScene.id }) { scene in
                                    SceneCardView(scene: scene, size: .standard, isDark: isDark) {
                                        path.append(scene)
                                    }
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.md)
                        }

                        // Locked
                        if !homeVM.lockedScenes.isEmpty {
                            SectionLabel("待解锁", isDark: isDark)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                                      spacing: AppConstants.Spacing.md) {
                                ForEach(homeVM.lockedScenes) { scene in
                                    SceneCardView(scene: scene, size: .locked, isDark: isDark)
                                }
                            }
                            .padding(.horizontal, AppConstants.Spacing.md)
                        }

                        Spacer(minLength: AppConstants.Spacing.xxl)
                    }
                }
            }
            .navigationDestination(for: Scene.self) { scene in
                DurationPickerView(scene: scene, path: $path, homeVM: homeVM)
            }
            .navigationDestination(for: FocusRoute.self) { route in
                FocusView(route: route, path: $path, homeVM: homeVM)
            }
            .navigationDestination(for: CompletionRoute.self) { route in
                CompletionView(route: route, path: $path, homeVM: homeVM)
            }
            .overlay {
                if homeVM.showUnlockPopup, let scene = homeVM.pendingUnlockScene {
                    UnlockPopupView(scene: scene) { homeVM.dismissUnlock() }
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: homeVM.showUnlockPopup)
        }
        .onLongPressGesture(minimumDuration: 0.6) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                DataManager.shared.themeStyle = isDark ? "softOrb" : "darkGlass"
            }
        }
    }
}

// MARK: - Dark Glass Background
struct DarkGlassBackground: View {
    @State private var phase: Double = 0
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex:"0A0E1A"), Color(hex:"1A0A2E")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            // subtle floating mesh
            TimelineView(.animation) { tl in
                Canvas { ctx, sz in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    for i in 0..<6 {
                        let seed = Double(i * 137)
                        let x = sz.width * (0.1 + 0.8 * ((seed * 0.618).truncatingRemainder(dividingBy: 1.0)))
                        let y = sz.height * (0.1 + 0.8 * ((seed * 0.382).truncatingRemainder(dividingBy: 1.0)))
                        let drift = CGFloat(sin(t * 0.3 + seed)) * 30
                        let r = sz.width * CGFloat(0.18 + (seed.truncatingRemainder(dividingBy: 0.1)))
                        let colors: [Color] = [Color(hex:"7B2FBE"), Color(hex:"0096C7"),
                                               Color(hex:"52B788"), Color(hex:"957DAD")]
                        ctx.fill(Path(ellipseIn: CGRect(x:x+drift-r, y:y-r, width:r*2, height:r*2)),
                                 with: .color(colors[i % colors.count].opacity(0.07)))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Soft Orb Background
struct SoftOrbBackground: View {
    var body: some View {
        ZStack {
            Color(hex:"F8F6FF").ignoresSafeArea()
            TimelineView(.animation) { tl in
                Canvas { ctx, sz in
                    let t = tl.date.timeIntervalSinceReferenceDate
                    let orbs: [(Color, Double, Double)] = [
                        (Color(hex:"FFB7C5"), 0.25, 0.28),
                        (Color(hex:"B5EAD7"), 0.72, 0.65),
                        (Color(hex:"C7B8EA"), 0.45, 0.82),
                    ]
                    for (color, bx, by) in orbs {
                        let ox = sz.width  * CGFloat(bx + sin(t * 0.18 + bx) * 0.08)
                        let oy = sz.height * CGFloat(by + cos(t * 0.22 + by) * 0.06)
                        let r  = sz.width  * CGFloat(0.38)
                        ctx.fill(Path(ellipseIn: CGRect(x:ox-r, y:oy-r, width:r*2, height:r*2)),
                                 with: .color(color.opacity(0.35)))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Header
struct HomeHeaderView: View {
    let isDark: Bool
    private var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "早上好 ☀️" }
        else if h < 18 { return "下午好 🌤" }
        else { return "晚上好 🌙" }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(greeting)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(isDark ? .white.opacity(0.6) : .secondary)
                Text("专注时光")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(isDark ? .white : .primary)
            }
            Spacer()
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(isDark ? Color(hex:"957DAD") : Color(hex:"957DAD"))
                .symbolEffect(.variableColor.iterative)
        }
    }
}

// MARK: - Stats Row
struct StatsRowView: View {
    let homeVM: HomeViewModel
    let isDark: Bool
    var body: some View {
        HStack(spacing: AppConstants.Spacing.sm) {
            StatChip(label: "今日", value: homeVM.todaySessions,
                     icon: "sun.max.fill", color: Color(hex:"F9844A"), isDark: isDark)
            StatChip(label: "本周", value: homeVM.weekSessions,
                     icon: "calendar", color: Color(hex:"4A90D9"), isDark: isDark)
            StatChip(label: "总计", value: homeVM.totalSessions,
                     icon: "checkmark.circle.fill", color: Color(hex:"52B788"), isDark: isDark)
            StatChip(label: "星星", value: homeVM.totalStars,
                     icon: "star.fill", color: Color(hex:"FFD700"), isDark: isDark)
        }
    }
}

// MARK: - Section Label
struct SectionLabel: View {
    let title: String
    let isDark: Bool
    init(_ title: String, isDark: Bool) { self.title = title; self.isDark = isDark }
    var body: some View {
        Text(title)
            .font(.system(.headline, design: .rounded, weight: .semibold))
            .foregroundStyle(isDark ? .white.opacity(0.85) : .primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppConstants.Spacing.md)
    }
}

// MARK: - Stat Chip
struct StatChip: View {
    let label: String
    let value: Int
    let icon: String
    let color: Color
    let isDark: Bool
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.caption).foregroundStyle(color)
            Text("\(value)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(isDark ? .white : .primary)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(isDark ? .white.opacity(0.5) : .secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppConstants.Spacing.sm)
        .background(isDark ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(.regularMaterial),
                    in: RoundedRectangle(cornerRadius: AppConstants.Radius.chip))
    }
}
```

**Step 2: Build check** — Cmd+B

**Step 3: Commit**
```bash
git add FocusMoments/Views/HomeView.swift
git commit -m "feat: dual-theme HomeView with Dark Glass and Soft Orb backgrounds"
```

---

### Task 7: SceneCardView — theme-aware styling

**Files:**
- Modify: `FocusMoments/Views/Components/SceneCardView.swift`

**Step 1: Add `isDark` parameter**

```swift
struct SceneCardView: View {
    let scene: Scene
    let size: CardSize
    var isDark: Bool = false
    var onTap: (() -> Void)? = nil
    @State private var isPressed = false

    var body: some View {
        ZStack {
            // background
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .fill(LinearGradient(colors: isDark
                    ? scene.cardGradient.map { $0.opacity(0.5) } + [.white.opacity(0.03)]
                    : scene.cardGradient,
                    startPoint: .topLeading, endPoint: .bottomTrailing))

            // glass overlay
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .fill(isDark ? .ultraThinMaterial.opacity(0.3) : .ultraThinMaterial.opacity(0.15))

            // border
            RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                .strokeBorder(isDark
                    ? LinearGradient(colors: [.white.opacity(0.2), .white.opacity(0.05)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing)
                    : LinearGradient(colors: scene.cardGradient + [.white.opacity(0.6)],
                                     startPoint: .topLeading, endPoint: .bottomTrailing),
                              lineWidth: isDark ? 1 : 1.5)

            VStack(spacing: AppConstants.Spacing.sm) {
                SceneAnimationView(sceneId: scene.id, size: size == .featured ? 140 : 90)
                    .allowsHitTesting(false)
                Text(scene.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(isDark ? .white : .white.shadow(.drop(radius: 2)))
                if size == .featured {
                    Text(scene.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(isDark ? .white.opacity(0.7) : .white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppConstants.Spacing.md)

            // locked overlay
            if size == .locked {
                RoundedRectangle(cornerRadius: AppConstants.Radius.card)
                    .fill(.ultraThinMaterial.opacity(0.6))
                VStack(spacing: 4) {
                    Image(systemName: "lock.fill").font(.title2).foregroundStyle(.white.opacity(0.8))
                    Text("需\(scene.unlockCount)次专注")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
        }
        .frame(height: size.height)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .shadow(color: isDark
            ? .black.opacity(0.4)
            : (scene.cardGradient.first ?? .gray).opacity(0.25),
                radius: 12, x: 0, y: 6)
        .onTapGesture {
            guard size != .locked else { return }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false; onTap?()
            }
        }
    }
}
```

**Step 2: Build check** — Cmd+B

**Step 3: Commit**
```bash
git add FocusMoments/Views/Components/SceneCardView.swift
git commit -m "feat: theme-aware SceneCardView (dark glass / soft orb)"
```

---

### Task 8: FocusView — pass progress to SceneAnimationView

**Files:**
- Modify: `FocusMoments/Views/FocusView.swift`

**Step 1: Update SceneAnimationView call in FocusView**

Find the line:
```swift
SceneAnimationView(sceneId: route.scene.id, size: geo.size.height * 0.52)
```
Replace with:
```swift
SceneAnimationView(sceneId: route.scene.id,
                   size: geo.size.height * 0.52,
                   progress: focusVM.progress)
```

**Step 2: Build check** — Cmd+B

**Step 3: Commit**
```bash
git add FocusMoments/Views/FocusView.swift
git commit -m "feat: pass focus progress to SceneAnimationView"
```

---

### Task 9: CompletionView — celebrating mode

**Files:**
- Modify: `FocusMoments/Views/CompletionView.swift`

**Step 1: Update SceneAnimationView call in CompletionView**

Find the line:
```swift
SceneAnimationView(sceneId: route.scene.id, size: 120)
```
Replace with:
```swift
SceneAnimationView(sceneId: route.scene.id,
                   size: 150,
                   progress: 1.0,
                   celebrating: true)
    .frame(width: 150, height: 150)
    .clipShape(RoundedRectangle(cornerRadius: 24))
```

**Step 2: Build check** — Cmd+B

**Step 3: Commit**
```bash
git add FocusMoments/Views/CompletionView.swift
git commit -m "feat: celebrating animation on completion screen"
```

---

### Task 10: Functional verification pass

**Verify each feature manually on simulator:**

1. **Timer** — Start 1-min session, confirm countdown reaches 0, navigates to CompletionView ✓
2. **Progress animation** — Start session, watch tree/scene evolve over time ✓
3. **Completion burst** — Confirm scene plays `celebrating: true` on CompletionView ✓
4. **Stats** — Complete session, return home, confirm today/total/stars increment ✓
5. **Unlock** — (Set DataManager.totalSessions=4 in debugger) complete one session → bird unlocks at 5 ✓
6. **Long-press theme** — Long press HomeView background 0.6s → theme switches ✓
7. **Theme persistence** — Kill app, reopen → theme remembered ✓
8. **Abandon** — Start session, abandon → no stats change ✓
9. **New scenes** — Manually unlock rain/campfire (set totalSessions high) → check animations display ✓

**Step 1: Push all commits**
```bash
git push healing master
```

---
