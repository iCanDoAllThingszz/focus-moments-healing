import SwiftUI

// MARK: - Router
struct SceneAnimationView: View {
    let sceneId: String
    var size: CGFloat = 200

    var body: some View {
        switch sceneId {
        case "tree":       TreeAnimation(size: size)
        case "cat":        CatAnimation(size: size)
        case "fish":       FishAnimation(size: size)
        case "bird":       BirdAnimation(size: size)
        case "moon":       MoonAnimation(size: size)
        case "flower":     FlowerAnimation(size: size)
        case "butterfly":  ButterflyAnimation(size: size)
        case "rainbow":    RainbowAnimation(size: size)
        default:           TreeAnimation(size: size)
        }
    }
}

// MARK: - Tree Animation
struct TreeAnimation: View {
    let size: CGFloat
    @State private var phase: Double = 0
    @State private var leafOpacity: Double = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let sway = sin(t * 0.8) * 0.06
                drawBranch(ctx: ctx, sz: sz, x: sz.width/2, y: sz.height*0.85,
                           angle: -.pi/2, length: sz.height*0.22, depth: 7, sway: sway, t: t)
            }
        }
        .frame(width: size, height: size)
    }

    func drawBranch(ctx: GraphicsContext, sz: CGSize, x: CGFloat, y: CGFloat,
                    angle: CGFloat, length: CGFloat, depth: Int, sway: CGFloat, t: Double) {
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
            let leafRect = CGRect(x: endX-leafR/2, y: endY-leafR/2, width: leafR, height: leafR)
            let leafAlpha = 0.5 + 0.5 * sin(t * 1.2 + Double(depth))
            ctx.fill(Path(ellipseIn: leafRect), with: .color(Color(red:0.3,green:0.7,blue:0.3).opacity(leafAlpha)))
        }
        let spread: CGFloat = .pi / 5
        drawBranch(ctx: ctx, sz: sz, x: endX, y: endY, angle: angle - spread,
                   length: length * 0.68, depth: depth-1, sway: sway, t: t)
        drawBranch(ctx: ctx, sz: sz, x: endX, y: endY, angle: angle + spread,
                   length: length * 0.68, depth: depth-1, sway: sway, t: t)
    }
}

// MARK: - Cat Animation
struct TailShape: Shape {
    var curl: CGFloat
    var animatableData: CGFloat {
        get { curl }
        set { curl = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w*0.5, y: h))
        p.addCurve(
            to: CGPoint(x: w*0.1, y: h*0.1),
            control1: CGPoint(x: w*(0.5 + curl*0.3), y: h*0.7),
            control2: CGPoint(x: w*0.8, y: h*0.3)
        )
        return p
    }
}

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

struct CatAnimation: View {
    let size: CGFloat
    @State private var breathScale: CGFloat = 1.0
    @State private var tailCurl: CGFloat = 0.3
    @State private var eyeClose: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                // glow
                Circle()
                    .fill(RadialGradient(colors:[Color(hex:"FFD3A5").opacity(0.4),.clear],
                                        center:.center, startRadius:0, endRadius:w*0.4))
                    .frame(width: w*0.8, height: w*0.8)
                    .scaleEffect(breathScale)
                    .position(x: w*0.5, y: h*0.52)
                // body
                Ellipse()
                    .fill(Color(hex:"F5CBA7"))
                    .frame(width: w*0.5, height: h*0.38)
                    .scaleEffect(x: 1, y: breathScale)
                    .position(x: w*0.5, y: h*0.62)
                // head
                Circle()
                    .fill(Color(hex:"F5CBA7"))
                    .frame(width: w*0.38, height: w*0.38)
                    .position(x: w*0.5, y: h*0.35)
                // ears
                CatEarShape()
                    .fill(Color(hex:"F5CBA7"))
                    .frame(width: w*0.1, height: w*0.12)
                    .position(x: w*0.38, y: h*0.21)
                CatEarShape()
                    .fill(Color(hex:"F5CBA7"))
                    .frame(width: w*0.1, height: w*0.12)
                    .position(x: w*0.62, y: h*0.21)
                // eyes (closed = sleeping)
                Capsule()
                    .fill(Color(hex:"6B4423"))
                    .frame(width: w*0.07, height: w*0.02)
                    .position(x: w*0.44, y: h*0.34)
                Capsule()
                    .fill(Color(hex:"6B4423"))
                    .frame(width: w*0.07, height: w*0.02)
                    .position(x: w*0.56, y: h*0.34)
                // nose
                Circle()
                    .fill(Color(hex:"FFB6C1"))
                    .frame(width: w*0.03, height: w*0.03)
                    .position(x: w*0.5, y: h*0.385)
                // tail
                TailShape(curl: tailCurl)
                    .stroke(Color(hex:"F5CBA7"), lineWidth: w*0.045)
                    .frame(width: w*0.25, height: h*0.35)
                    .position(x: w*0.72, y: h*0.7)
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

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate

                // water surface waves
                for i in 0..<4 {
                    var wave = Path()
                    let yBase = sz.height * (0.55 + Double(i) * 0.06)
                    wave.move(to: CGPoint(x: 0, y: yBase))
                    for x in stride(from: 0.0, through: sz.width, by: 2.0) {
                        let y = yBase + sin(x * 0.04 + t * 2.0 + Double(i)) * 4
                        wave.addLine(to: CGPoint(x: x, y: y))
                    }
                    ctx.stroke(wave, with: .color(Color(hex:"48CAE4").opacity(0.3 - Double(i)*0.05)), lineWidth: 1.5)
                }

                // bubbles
                for i in 0..<5 {
                    let bx = sz.width * (0.2 + Double(i) * 0.15)
                    let by = sz.height * (0.7 - fmod(t * 0.3 + Double(i)*0.4, 0.8) * 0.6)
                    let br = CGFloat(3 + i % 3)
                    ctx.stroke(Path(ellipseIn: CGRect(x:bx-br, y:by-br, width:br*2, height:br*2)),
                               with: .color(Color(hex:"ADE8F4").opacity(0.6)), lineWidth: 1)
                }

                // fish body
                let fishX = sz.width * (0.3 + 0.4 * (sin(t * 0.7) * 0.5 + 0.5))
                let fishY = sz.height * (0.4 + sin(t * 1.1) * 0.08)
                let flip = cos(t * 0.7) < 0
                ctx.translateBy(x: fishX, y: fishY)
                if flip { ctx.scaleBy(x: -1, y: 1) }

                var body = Path()
                body.move(to: CGPoint(x: 0, y: 0))
                body.addCurve(to: CGPoint(x: -sz.width*0.12, y: 0),
                              control1: CGPoint(x: -sz.width*0.04, y: -sz.height*0.05),
                              control2: CGPoint(x: -sz.width*0.08, y: -sz.height*0.05))
                body.addCurve(to: CGPoint(x: 0, y: 0),
                              control1: CGPoint(x: -sz.width*0.08, y: sz.height*0.05),
                              control2: CGPoint(x: -sz.width*0.04, y: sz.height*0.05))
                ctx.fill(body, with: .color(Color(hex:"0096C7")))

                var tail = Path()
                let tw = sz.width * 0.06
                let tailWag = sin(t * 4) * 0.15
                tail.move(to: CGPoint(x: -sz.width*0.12, y: 0))
                tail.addLine(to: CGPoint(x: -sz.width*0.12 - tw, y: -sz.height*0.05 + tailWag*sz.height))
                tail.addLine(to: CGPoint(x: -sz.width*0.12 - tw, y:  sz.height*0.05 + tailWag*sz.height))
                tail.closeSubpath()
                ctx.fill(tail, with: .color(Color(hex:"48CAE4")))

                ctx.fill(Path(ellipseIn: CGRect(x:-sz.width*0.008, y:-sz.width*0.008,
                                                width:sz.width*0.016, height:sz.width*0.016)),
                         with: .color(.white))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Bird Animation
struct BirdAnimation: View {
    let size: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate

                // tree/nest base
                var trunk = Path()
                trunk.move(to: CGPoint(x: sz.width*0.5, y: sz.height))
                trunk.addLine(to: CGPoint(x: sz.width*0.5, y: sz.height*0.65))
                ctx.stroke(trunk, with: .color(Color(hex:"8B4513")), lineWidth: 6)

                for side: CGFloat in [-1, 1] {
                    var branch = Path()
                    branch.move(to: CGPoint(x: sz.width*0.5, y: sz.height*0.72))
                    branch.addQuadCurve(to: CGPoint(x: sz.width*0.5 + side*sz.width*0.28, y: sz.height*0.6),
                                        control: CGPoint(x: sz.width*0.5 + side*sz.width*0.1, y: sz.height*0.62))
                    ctx.stroke(branch, with: .color(Color(hex:"8B4513")), lineWidth: 3)
                }

                // nest
                var nest = Path()
                nest.addArc(center: CGPoint(x: sz.width*0.5, y: sz.height*0.65),
                            radius: sz.width*0.1, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                ctx.stroke(nest, with: .color(Color(hex:"A0522D")), lineWidth: 4)

                // flying bird
                let cycle = fmod(t * 0.5, 1.0)
                let birdX = sz.width * cycle
                let birdY = sz.height * (0.25 + sin(cycle * .pi) * 0.15)
                let wingFlap = sin(t * 8) * 0.3

                ctx.translateBy(x: birdX, y: birdY)
                for side: CGFloat in [-1, 1] {
                    var wing = Path()
                    wing.move(to: .zero)
                    wing.addQuadCurve(
                        to: CGPoint(x: side * sz.width*0.06, y: sz.height*0.03 + wingFlap*sz.height*0.06),
                        control: CGPoint(x: side * sz.width*0.04, y: -sz.height*0.03)
                    )
                    ctx.stroke(wing, with: .color(Color(hex:"4A4A8A")), lineWidth: 2)
                }
                ctx.fill(Path(ellipseIn: CGRect(x:-3, y:-2, width:6, height:4)),
                         with: .color(Color(hex:"4A4A8A")))
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Moon Animation
struct MoonAnimation: View {
    let size: CGFloat

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate

                // stars twinkling
                let starPositions: [(CGFloat, CGFloat)] = [
                    (0.1,0.1),(0.3,0.08),(0.7,0.05),(0.85,0.12),(0.15,0.25),
                    (0.55,0.15),(0.9,0.3),(0.05,0.4),(0.75,0.2),(0.45,0.08)
                ]
                for (i, pos) in starPositions.enumerated() {
                    let alpha = 0.4 + 0.6 * sin(t * 1.5 + Double(i) * 0.8)
                    let r: CGFloat = i % 3 == 0 ? 2.5 : 1.5
                    ctx.fill(Path(ellipseIn: CGRect(x: sz.width*pos.0-r, y: sz.height*pos.1-r, width:r*2, height:r*2)),
                             with: .color(Color.white.opacity(alpha)))
                }

                // moon rise
                let riseProgress = min(1.0, t / 4.0)
                let moonY = sz.height * (0.9 - riseProgress * 0.6)
                let moonR = sz.width * 0.18

                // glow
                let glowAlpha = riseProgress * 0.3
                ctx.fill(Path(ellipseIn: CGRect(x:sz.width*0.5-moonR*1.8, y:moonY-moonR*1.8,
                                                width:moonR*3.6, height:moonR*3.6)),
                         with: .color(Color(hex:"FFF9C4").opacity(glowAlpha)))

                // moon
                ctx.fill(Path(ellipseIn: CGRect(x:sz.width*0.5-moonR, y:moonY-moonR,
                                                width:moonR*2, height:moonR*2)),
                         with: .color(Color(hex:"FFFDE7")))

                // crescent shadow
                ctx.fill(Path(ellipseIn: CGRect(x:sz.width*0.5-moonR*0.6, y:moonY-moonR,
                                                width:moonR*1.5, height:moonR*2)),
                         with: .color(Color(hex:"03045E").opacity(0.7 * riseProgress)))
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
        p.move(to: CGPoint(x: w/2, y: h))
        p.addCurve(to: CGPoint(x: w/2, y: 0),
                   control1: CGPoint(x: w, y: h*0.6),
                   control2: CGPoint(x: w, y: h*0.1))
        p.addCurve(to: CGPoint(x: w/2, y: h),
                   control1: CGPoint(x: 0, y: h*0.1),
                   control2: CGPoint(x: 0, y: h*0.6))
        return p
    }
}

struct FlowerAnimation: View {
    let size: CGFloat
    @State private var bloom: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var fallenOffset: [CGSize] = Array(repeating: .zero, count: 6)

    let petalColors: [Color] = [
        Color(hex:"FFB7C5"), Color(hex:"FF85A1"),
        Color(hex:"E8B4E8"), Color(hex:"D291BC"),
        Color(hex:"FFB7C5"), Color(hex:"FF85A1")
    ]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cx = w/2, cy = h/2
            let petalH = w * 0.35
            let petalW = w * 0.15

            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    PetalShape()
                        .fill(petalColors[i])
                        .frame(width: petalW, height: petalH * bloom)
                        .rotationEffect(.degrees(Double(i) * 60 + rotation))
                        .offset(y: -petalH * 0.4 * bloom)
                        .position(x: cx, y: cy)
                        .opacity(Double(bloom))
                }
                // center
                Circle()
                    .fill(Color(hex:"FFD700"))
                    .frame(width: w*0.12, height: w*0.12)
                    .position(x: cx, y: cy)
                // stem
                Rectangle()
                    .fill(Color(hex:"52B788"))
                    .frame(width: 3, height: h*0.25)
                    .position(x: cx, y: cy + h*0.22)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.spring(response: 1.5, dampingFraction: 0.6).delay(0.2)) {
                bloom = 1.0
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Butterfly Animation
struct ButterflyAnimation: View {
    let size: CGFloat

    func drawWings(ctx: GraphicsContext, sz: CGSize, flap: CGFloat, color: Color) {
        for side: CGFloat in [-1, 1] {
            var wing = Path()
            let cx = sz.width/2, cy = sz.height/2
            wing.move(to: CGPoint(x: cx, y: cy))
            wing.addCurve(
                to: CGPoint(x: cx + side*sz.width*0.3, y: cy - sz.height*0.28*flap),
                control1: CGPoint(x: cx + side*sz.width*0.05, y: cy - sz.height*0.3*flap),
                control2: CGPoint(x: cx + side*sz.width*0.25, y: cy - sz.height*0.38*flap)
            )
            wing.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: cx + side*sz.width*0.35, y: cy - sz.height*0.05),
                control2: CGPoint(x: cx + side*sz.width*0.1, y: cy + sz.height*0.05)
            )
            // lower wing
            wing.move(to: CGPoint(x: cx, y: cy))
            wing.addCurve(
                to: CGPoint(x: cx + side*sz.width*0.22, y: cy + sz.height*0.22*flap),
                control1: CGPoint(x: cx + side*sz.width*0.04, y: cy + sz.height*0.15*flap),
                control2: CGPoint(x: cx + side*sz.width*0.18, y: cy + sz.height*0.28*flap)
            )
            wing.addCurve(
                to: CGPoint(x: cx, y: cy),
                control1: CGPoint(x: cx + side*sz.width*0.25, y: cy + sz.height*0.15),
                control2: CGPoint(x: cx + side*sz.width*0.05, y: cy + sz.height*0.08)
            )
            ctx.fill(wing, with: .color(color.opacity(0.85)))
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate
                let flap = CGFloat(0.6 + 0.4 * sin(t * 6))

                // Lissajous flight path
                let bx = sz.width/2 + sz.width*0.35*CGFloat(sin(t * 0.7))
                let by = sz.height/2 + sz.height*0.3*CGFloat(sin(t * 1.1))

                ctx.translateBy(x: bx - sz.width/2, y: by - sz.height/2)

                drawWings(ctx: ctx, sz: sz, flap: flap, color: Color(hex:"F9844A"))

                // body
                var body = Path()
                body.addEllipse(in: CGRect(x: sz.width/2-3, y: sz.height/2-10, width: 6, height: 20))
                ctx.fill(body, with: .color(Color(hex:"795548")))

                // antennae
                for side: CGFloat in [-1, 1] {
                    var ant = Path()
                    ant.move(to: CGPoint(x: sz.width/2, y: sz.height/2-10))
                    ant.addQuadCurve(
                        to: CGPoint(x: sz.width/2 + side*12, y: sz.height/2-22),
                        control: CGPoint(x: sz.width/2 + side*6, y: sz.height/2-14)
                    )
                    ctx.stroke(ant, with: .color(Color(hex:"795548")), lineWidth: 1)
                    ctx.fill(Path(ellipseIn: CGRect(x:sz.width/2+side*12-2, y:sz.height/2-24, width:4, height:4)),
                             with: .color(Color(hex:"795548")))
                }
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Rainbow Animation
struct RainbowAnimation: View {
    let size: CGFloat
    let rainbowColors: [Color] = [
        Color(hex:"FF0000"), Color(hex:"FF7F00"), Color(hex:"FFFF00"),
        Color(hex:"00FF00"), Color(hex:"0000FF"), Color(hex:"8B00FF")
    ]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let t = timeline.date.timeIntervalSinceReferenceDate

                // rain drops
                for i in 0..<20 {
                    let rx = sz.width * CGFloat(i) / 20.0 + CGFloat(i % 3) * 10
                    let ry = fmod(CGFloat(t) * 150 + CGFloat(i * 30), sz.height * 0.6)
                    var drop = Path()
                    drop.move(to: CGPoint(x: rx, y: ry))
                    drop.addLine(to: CGPoint(x: rx, y: ry + 8))
                    ctx.stroke(drop, with: .color(Color(hex:"90CAF9").opacity(0.5)), lineWidth: 1)
                }

                // clouds
                func drawCloud(cx: CGFloat, cy: CGFloat, scale: CGFloat) {
                    for offset in [(0.0,0.0),(-0.4,0.3),(0.4,0.3),(-0.8,0.5),(0.8,0.5)] {
                        let r = sz.width * 0.08 * scale
                        ctx.fill(Path(ellipseIn: CGRect(
                            x: cx + sz.width*CGFloat(offset.0)*scale*0.5 - r,
                            y: cy + sz.height*CGFloat(offset.1)*scale*0.3 - r,
                            width: r*2, height: r*2)),
                            with: .color(Color.white.opacity(0.9)))
                    }
                }
                drawCloud(cx: sz.width*0.2, cy: sz.height*0.15, scale: 1.0)
                drawCloud(cx: sz.width*0.75, cy: sz.height*0.12, scale: 0.8)

                // rainbow arcs
                let showProgress = min(1.0, max(0.0, t / 5.0))
                let center = CGPoint(x: sz.width/2, y: sz.height*0.75)
                for (i, color) in rainbowColors.reversed().enumerated() {
                    let r = sz.width * (0.22 + CGFloat(i) * 0.05)
                    let arcEnd = showProgress * 180.0
                    var arc = Path()
                    arc.addArc(center: center, radius: r,
                               startAngle: .degrees(180), endAngle: .degrees(180 + arcEnd), clockwise: false)
                    ctx.stroke(arc, with: .color(color.opacity(0.75)), lineWidth: 5)
                }
            }
        }
        .frame(width: size, height: size)
    }
}
