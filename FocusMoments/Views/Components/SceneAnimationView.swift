import SwiftUI

// MARK: - Router
struct SceneAnimationView: View {
    let sceneId: String
    var size: CGFloat = 200
    var progress: Double = 0
    var celebrating: Bool = false

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

// MARK: - Tree Animation
struct TreeAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let sway = sin(t * 0.8) * 0.06
                let depth = Int(2 + progress * 5)
                let trunkH = sz.height * (0.15 + CGFloat(progress) * 0.25)
                drawBranch(ctx: ctx, sz: sz,
                           x: sz.width/2, y: sz.height * 0.9,
                           angle: -.pi/2, length: trunkH,
                           depth: depth, sway: sway, t: t, progress: progress)
                if celebrating {
                    for i in 0..<40 {
                        let seed = Double(i * 137)
                        let lx = sz.width * (seed * 0.618).truncatingRemainder(dividingBy: 1.0)
                        let ly = sz.height * fmod(seed * 0.382 + t * 0.4, 1.0)
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

// MARK: - Cat Animation
struct CatEarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct TailShape: Shape {
    var curl: CGFloat
    var animatableData: CGFloat {
        get { curl }
        set { curl = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: h))
        p.addCurve(
            to: CGPoint(x: w * 0.1, y: h * 0.1),
            control1: CGPoint(x: w * (0.5 + curl * 0.3), y: h * 0.7),
            control2: CGPoint(x: w * 0.8, y: h * 0.3)
        )
        return p
    }
}

struct CatAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false
    @State private var breathScale: CGFloat = 1.0
    @State private var tailCurl: CGFloat = 0.3

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "FFD3A5").opacity(0.4), .clear],
                                        center: .center, startRadius: 0, endRadius: w * 0.4))
                    .frame(width: w * 0.8, height: w * 0.8)
                    .scaleEffect(breathScale)
                    .position(x: w * 0.5, y: h * 0.52)
                Ellipse()
                    .fill(Color(hex: "F5CBA7"))
                    .frame(width: w * 0.5, height: h * 0.38)
                    .scaleEffect(x: 1, y: breathScale)
                    .position(x: w * 0.5, y: h * 0.62)
                Circle()
                    .fill(Color(hex: "F5CBA7"))
                    .frame(width: w * 0.38, height: w * 0.38)
                    .position(x: w * 0.5, y: h * 0.35)
                CatEarShape()
                    .fill(Color(hex: "F5CBA7"))
                    .frame(width: w * 0.1, height: w * 0.12)
                    .position(x: w * 0.38, y: h * 0.21)
                CatEarShape()
                    .fill(Color(hex: "F5CBA7"))
                    .frame(width: w * 0.1, height: w * 0.12)
                    .position(x: w * 0.62, y: h * 0.21)
                Capsule()
                    .fill(Color(hex: "6B4423"))
                    .frame(width: w * 0.07, height: w * 0.02)
                    .position(x: w * 0.44, y: h * 0.34)
                Capsule()
                    .fill(Color(hex: "6B4423"))
                    .frame(width: w * 0.07, height: w * 0.02)
                    .position(x: w * 0.56, y: h * 0.34)
                Circle()
                    .fill(Color(hex: "FFB6C1"))
                    .frame(width: w * 0.03, height: w * 0.03)
                    .position(x: w * 0.5, y: h * 0.385)
                TailShape(curl: tailCurl)
                    .stroke(Color(hex: "F5CBA7"), lineWidth: w * 0.045)
                    .frame(width: w * 0.25, height: h * 0.35)
                    .position(x: w * 0.72, y: h * 0.7)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                breathScale = 1.06
            }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                tailCurl = 0.7
            }
        }
    }
}

// MARK: - Fish Animation
struct FishAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for i in 0 ..< 4 {
                    var wave = Path()
                    let yBase = sz.height * (0.55 + Double(i) * 0.06)
                    wave.move(to: CGPoint(x: 0, y: yBase))
                    var xv: Double = 0
                    while xv <= Double(sz.width) {
                        let y = yBase + sin(xv * 0.04 + t * 2.0 + Double(i)) * 4
                        wave.addLine(to: CGPoint(x: xv, y: y))
                        xv += 2
                    }
                    ctx.stroke(wave, with: .color(Color(hex: "48CAE4").opacity(0.3 - Double(i) * 0.05)),
                               lineWidth: 1.5)
                }
                for i in 0 ..< 5 {
                    let bx = sz.width * (0.2 + Double(i) * 0.15)
                    let by = sz.height * (0.7 - fmod(t * 0.3 + Double(i) * 0.4, 0.8) * 0.6)
                    let br = CGFloat(3 + i % 3)
                    ctx.stroke(Path(ellipseIn: CGRect(x: bx - br, y: by - br, width: br * 2, height: br * 2)),
                               with: .color(Color(hex: "ADE8F4").opacity(0.6)), lineWidth: 1)
                }
                let fishX = sz.width * (0.3 + 0.4 * (sin(t * 0.7) * 0.5 + 0.5))
                let fishY = sz.height * (0.4 + sin(t * 1.1) * 0.08)
                let flip = cos(t * 0.7) < 0
                var fishCtx = ctx
                fishCtx.translateBy(x: fishX, y: fishY)
                if flip { fishCtx.scaleBy(x: -1, y: 1) }
                let fw = sz.width * 0.12
                var fishBody = Path()
                fishBody.move(to: CGPoint(x: 0, y: 0))
                fishBody.addCurve(to: CGPoint(x: -fw, y: 0),
                                  control1: CGPoint(x: -fw * 0.33, y: -sz.height * 0.05),
                                  control2: CGPoint(x: -fw * 0.67, y: -sz.height * 0.05))
                fishBody.addCurve(to: CGPoint(x: 0, y: 0),
                                  control1: CGPoint(x: -fw * 0.67, y: sz.height * 0.05),
                                  control2: CGPoint(x: -fw * 0.33, y: sz.height * 0.05))
                fishCtx.fill(fishBody, with: .color(Color(hex: "0096C7")))
                let tw = sz.width * 0.06
                let tailWag = CGFloat(sin(t * 4) * 0.15)
                var tailPath = Path()
                tailPath.move(to: CGPoint(x: -fw, y: 0))
                tailPath.addLine(to: CGPoint(x: -fw - tw, y: -sz.height * 0.05 + tailWag * sz.height))
                tailPath.addLine(to: CGPoint(x: -fw - tw, y: sz.height * 0.05 + tailWag * sz.height))
                tailPath.closeSubpath()
                fishCtx.fill(tailPath, with: .color(Color(hex: "48CAE4")))
                let er = sz.width * 0.008
                fishCtx.fill(Path(ellipseIn: CGRect(x: -er, y: -er, width: er * 2, height: er * 2)),
                             with: .color(.white))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Bird Animation
struct BirdAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                var trunk = Path()
                trunk.move(to: CGPoint(x: sz.width * 0.5, y: sz.height))
                trunk.addLine(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.65))
                ctx.stroke(trunk, with: .color(Color(hex: "8B4513")), lineWidth: 6)
                let branchDirs: [CGFloat] = [-1, 1]
                for side in branchDirs {
                    var branch = Path()
                    branch.move(to: CGPoint(x: sz.width * 0.5, y: sz.height * 0.72))
                    branch.addQuadCurve(
                        to: CGPoint(x: sz.width * 0.5 + side * sz.width * 0.28, y: sz.height * 0.6),
                        control: CGPoint(x: sz.width * 0.5 + side * sz.width * 0.1, y: sz.height * 0.62))
                    ctx.stroke(branch, with: .color(Color(hex: "8B4513")), lineWidth: 3)
                }
                var nest = Path()
                nest.addArc(center: CGPoint(x: sz.width * 0.5, y: sz.height * 0.65),
                            radius: sz.width * 0.1,
                            startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                ctx.stroke(nest, with: .color(Color(hex: "A0522D")), lineWidth: 4)
                let cycle = fmod(t * 0.5, 1.0)
                let birdX = sz.width * cycle
                let birdY = sz.height * (0.25 + sin(cycle * .pi) * 0.15)
                let wingFlap = CGFloat(sin(t * 8) * 0.3)
                var birdCtx = ctx
                birdCtx.translateBy(x: birdX, y: birdY)
                for side in branchDirs {
                    var wing = Path()
                    wing.move(to: .zero)
                    wing.addQuadCurve(
                        to: CGPoint(x: side * sz.width * 0.06,
                                    y: sz.height * 0.03 + wingFlap * sz.height * 0.06),
                        control: CGPoint(x: side * sz.width * 0.04, y: -sz.height * 0.03))
                    birdCtx.stroke(wing, with: .color(Color(hex: "4A4A8A")), lineWidth: 2)
                }
                birdCtx.fill(Path(ellipseIn: CGRect(x: -3, y: -2, width: 6, height: 4)),
                             with: .color(Color(hex: "4A4A8A")))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Moon Animation
struct MoonAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    let starPositions: [(CGFloat, CGFloat)] = [
        (0.1, 0.1), (0.3, 0.08), (0.7, 0.05), (0.85, 0.12), (0.15, 0.25),
        (0.55, 0.15), (0.9, 0.3), (0.05, 0.4), (0.75, 0.2), (0.45, 0.08)
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for (i, pos) in self.starPositions.enumerated() {
                    let alpha = 0.4 + 0.6 * sin(t * 1.5 + Double(i) * 0.8)
                    let r: CGFloat = i % 3 == 0 ? 2.5 : 1.5
                    ctx.fill(Path(ellipseIn: CGRect(x: sz.width * pos.0 - r,
                                                    y: sz.height * pos.1 - r,
                                                    width: r * 2, height: r * 2)),
                             with: .color(Color.white.opacity(alpha)))
                }
                let riseProgress = CGFloat(progress)
                let moonY = sz.height * (0.9 - riseProgress * 0.6)
                let moonR = sz.width * 0.18
                ctx.fill(Path(ellipseIn: CGRect(x: sz.width * 0.5 - moonR * 1.8,
                                                y: moonY - moonR * 1.8,
                                                width: moonR * 3.6, height: moonR * 3.6)),
                         with: .color(Color(hex: "FFF9C4").opacity(riseProgress * 0.3)))
                ctx.fill(Path(ellipseIn: CGRect(x: sz.width * 0.5 - moonR,
                                                y: moonY - moonR,
                                                width: moonR * 2, height: moonR * 2)),
                         with: .color(Color(hex: "FFFDE7")))
                ctx.fill(Path(ellipseIn: CGRect(x: sz.width * 0.5 - moonR * 0.6,
                                                y: moonY - moonR,
                                                width: moonR * 1.5, height: moonR * 2)),
                         with: .color(Color(hex: "03045E").opacity(0.7 * riseProgress)))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Flower Animation
struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w / 2, y: h))
        p.addCurve(to: CGPoint(x: w / 2, y: 0),
                   control1: CGPoint(x: w, y: h * 0.6),
                   control2: CGPoint(x: w, y: h * 0.1))
        p.addCurve(to: CGPoint(x: w / 2, y: h),
                   control1: CGPoint(x: 0, y: h * 0.1),
                   control2: CGPoint(x: 0, y: h * 0.6))
        return p
    }
}

struct FlowerAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false
    var bloom: CGFloat { CGFloat(progress) }
    @State private var rotation: Double = 0

    let petalColors: [Color] = [
        Color(hex: "FFB7C5"), Color(hex: "FF85A1"),
        Color(hex: "E8B4E8"), Color(hex: "D291BC"),
        Color(hex: "FFB7C5"), Color(hex: "FF85A1")
    ]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cx = w / 2
            let cy = h / 2
            let petalH = w * 0.35
            let petalW = w * 0.15
            ZStack {
                ForEach(0 ..< 6, id: \.self) { i in
                    PetalShape()
                        .fill(petalColors[i])
                        .frame(width: petalW, height: petalH * bloom)
                        .rotationEffect(.degrees(Double(i) * 60 + rotation))
                        .offset(y: -petalH * 0.4 * bloom)
                        .position(x: cx, y: cy)
                        .opacity(Double(bloom))
                }
                Circle()
                    .fill(Color(hex: "FFD700"))
                    .frame(width: w * 0.12, height: w * 0.12)
                    .position(x: cx, y: cy)
                Rectangle()
                    .fill(Color(hex: "52B788"))
                    .frame(width: 3, height: h * 0.25)
                    .position(x: cx, y: cy + h * 0.22)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Butterfly Animation
struct ButterflyAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false

    func drawWings(in ctx: inout GraphicsContext, sz: CGSize, flap: CGFloat, color: Color) {
        let cx = sz.width / 2
        let cy = sz.height / 2
        let dirs: [CGFloat] = [-1, 1]
        for side in dirs {
            var upperWing = Path()
            upperWing.move(to: CGPoint(x: cx, y: cy))
            upperWing.addCurve(
                to: CGPoint(x: cx + side * sz.width * 0.3, y: cy - sz.height * 0.28 * flap),
                control1: CGPoint(x: cx + side * sz.width * 0.05, y: cy - sz.height * 0.3 * flap),
                control2: CGPoint(x: cx + side * sz.width * 0.25, y: cy - sz.height * 0.38 * flap))
            upperWing.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: cx + side * sz.width * 0.35, y: cy - sz.height * 0.05),
                control2: CGPoint(x: cx + side * sz.width * 0.1, y: cy + sz.height * 0.05))
            ctx.fill(upperWing, with: .color(color.opacity(0.85)))

            var lowerWing = Path()
            lowerWing.move(to: CGPoint(x: cx, y: cy))
            lowerWing.addCurve(
                to: CGPoint(x: cx + side * sz.width * 0.22, y: cy + sz.height * 0.22 * flap),
                control1: CGPoint(x: cx + side * sz.width * 0.04, y: cy + sz.height * 0.15 * flap),
                control2: CGPoint(x: cx + side * sz.width * 0.18, y: cy + sz.height * 0.28 * flap))
            lowerWing.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: cx + side * sz.width * 0.25, y: cy + sz.height * 0.15),
                control2: CGPoint(x: cx + side * sz.width * 0.05, y: cy + sz.height * 0.08))
            ctx.fill(lowerWing, with: .color(color.opacity(0.85)))
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let butterflyCount = max(1, Int(progress * 2.5) + 1)
                for bIdx in 0..<min(butterflyCount, 3) {
                    let bOffset = Double(bIdx) * 2.1
                    let flap = CGFloat(0.6 + 0.4 * sin(t * 6 + bOffset))
                    let bx = sz.width/2 + sz.width*0.35*CGFloat(sin(t * 0.7 + bOffset))
                    let by = sz.height/2 + sz.height*0.3*CGFloat(sin(t * 1.1 + bOffset))
                    var bCtx = ctx
                    bCtx.translateBy(x: bx - sz.width/2, y: by - sz.height/2)
                    drawWings(in: &bCtx, sz: sz, flap: flap, color: Color(hex:"F9844A"))
                    var body = Path()
                    body.addEllipse(in: CGRect(x: sz.width/2-3, y: sz.height/2-10, width: 6, height: 20))
                    bCtx.fill(body, with: .color(Color(hex:"795548")))
                    let dirs: [CGFloat] = [-1, 1]
                    for side in dirs {
                        var ant = Path()
                        ant.move(to: CGPoint(x: sz.width/2, y: sz.height/2-10))
                        ant.addQuadCurve(
                            to: CGPoint(x: sz.width/2 + side*12, y: sz.height/2-22),
                            control: CGPoint(x: sz.width/2 + side*6, y: sz.height/2-14)
                        )
                        bCtx.stroke(ant, with: .color(Color(hex:"795548")), lineWidth: 1)
                        bCtx.fill(Path(ellipseIn: CGRect(x:sz.width/2+side*12-2, y:sz.height/2-24, width:4, height:4)),
                                  with: .color(Color(hex:"795548")))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Rainbow Animation
struct RainbowCloud {
    let cx: CGFloat
    let cy: CGFloat
    let scale: CGFloat
    let offsets: [(CGFloat, CGFloat)] = [(0, 0), (-0.4, 0.3), (0.4, 0.3), (-0.8, 0.5), (0.8, 0.5)]
}

struct RainbowAnimation: View {
    let size: CGFloat
    var progress: Double = 0
    var celebrating: Bool = false
    let rainbowColors: [Color] = [
        Color(hex: "FF0000"), Color(hex: "FF7F00"), Color(hex: "FFFF00"),
        Color(hex: "00FF00"), Color(hex: "0000FF"), Color(hex: "8B00FF")
    ]
    let clouds: [RainbowCloud] = [
        RainbowCloud(cx: 0.2, cy: 0.15, scale: 1.0),
        RainbowCloud(cx: 0.75, cy: 0.12, scale: 0.8)
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                for i in 0 ..< 20 {
                    let rx = sz.width * CGFloat(i) / 20.0 + CGFloat(i % 3) * 10
                    let ry = fmod(CGFloat(t) * 150 + CGFloat(i * 30), sz.height * 0.6)
                    var drop = Path()
                    drop.move(to: CGPoint(x: rx, y: ry))
                    drop.addLine(to: CGPoint(x: rx, y: ry + 8))
                    ctx.stroke(drop, with: .color(Color(hex: "90CAF9").opacity(0.5)), lineWidth: 1)
                }
                for cloud in self.clouds {
                    for offset in cloud.offsets {
                        let r = sz.width * 0.08 * cloud.scale
                        let ox = sz.width * cloud.cx + sz.width * offset.0 * cloud.scale * 0.5
                        let oy = sz.height * cloud.cy + sz.height * offset.1 * cloud.scale * 0.3
                        ctx.fill(Path(ellipseIn: CGRect(x: ox - r, y: oy - r,
                                                        width: r * 2, height: r * 2)),
                                 with: .color(Color.white.opacity(0.9)))
                    }
                }
                let showProgress = progress
                let center = CGPoint(x: sz.width / 2, y: sz.height * 0.75)
                for (i, color) in rainbowColors.reversed().enumerated() {
                    let r = sz.width * (0.22 + CGFloat(i) * 0.05)
                    let arcEnd = showProgress * 180.0
                    var arc = Path()
                    arc.addArc(center: center, radius: r,
                               startAngle: .degrees(180),
                               endAngle: .degrees(180 + arcEnd),
                               clockwise: false)
                    ctx.stroke(arc, with: .color(color.opacity(0.75)), lineWidth: 5)
                }
            }
        }
        .frame(width: size, height: size)
    }
}
