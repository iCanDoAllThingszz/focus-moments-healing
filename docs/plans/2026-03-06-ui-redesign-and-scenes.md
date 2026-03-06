# FocusMoments UI Redesign & Scene Expansion

Date: 2026-03-06

## Goals

1. Dual-theme home UI (Dark Glass / Soft Orb), long-press to switch
2. Progress-aware animations — scenes evolve over focus session duration
3. Per-scene completion burst animation
4. 6 new scenes (3 nature + 3 cosmic)
5. Bug verification pass on all core features

---

## Theme System

### Dark Glass (暗黑玻璃)
- Background: deep navy `#0A0E1A` → deep purple `#1A0A2E`
- Floating mesh: subtle Canvas noise texture with slow drift
- Cards: `.ultraThinMaterial` + 1pt white/15% border + inner glow
- Stats: dark pill chips, white text
- Typography: white primary, white.opacity(0.6) secondary

### Soft Orb (光晕治愈)
- Background: near-white `#F8F6FF`
- 3 animated orbs (Canvas + TimelineView): pink, mint, lavender — Lissajous drift, radius ~35% screen
- Cards: white.opacity(0.7) + colored drop shadow from scene gradient
- Stats: light frosted chips
- Typography: dark primary

### Switching
- `DataManager.themeStyle: String` ("darkGlass" / "softOrb"), UserDefaults
- `HomeView` long-press gesture → haptic heavy → `withAnimation(.spring(response:0.6, dampingFraction:0.8))` theme toggle

---

## Progress-Aware Animations

### Interface change
```swift
SceneAnimationView(sceneId: String, size: CGFloat, progress: Double = 0, celebrating: Bool = false)
```

### Per-scene evolution

| Scene | 0% | 50% | 100% | Celebration |
|---|---|---|---|---|
| tree | seedling (depth 2) | young tree (depth 5) | full tree (depth 7) + falling leaves | golden leaf burst |
| cat | awake, curious | drowsy | deep sleep, purring glow | floating hearts |
| fish | 1 small fish | 2 fish, bigger | school of fish, coral grows | fish leap out |
| bird | empty branch | nest half built | nest complete, eggs | birds fly off |
| moon | horizon glow | half risen | full moon high | moonbeam fireworks |
| flower | bud closed | half open | full bloom | petals scatter |
| butterfly | 1 butterfly slow | 2 butterflies | 3 butterflies fast | spiral burst |
| rainbow | clouds only | half arc | full arc | sparkle shower |
| rain | light drizzle | steady rain | heavy rain + thunder flash | rainbow appears |
| campfire | tiny flame | medium fire | roaring fire + sparks | sparks explode |
| snow | sparse flakes | steady snow | blizzard, ground covered | snowflake mandala |
| aurora | faint green band | flowing curtains | full spectrum dance | aurora nova |
| meteor | 1 slow streak | 3 streaks | shower + constellations | meteor burst |
| planet | 1 planet slow | 2 planets | 3 planets + rings | orbital fireworks |

---

## New Scenes (6)

```
rain:     雨中咖啡  — unlock 15   — blue/grey gradients
campfire: 篝火夜晚  — unlock 25   — amber/deep red
snow:     初雪飘落  — unlock 40   — white/ice blue
aurora:   极光涌动  — unlock 60   — deep teal/purple
meteor:   流星许愿  — unlock 80   — midnight blue/gold
planet:   星球轨道  — unlock 100  — deep space/cosmic purple
```

---

## Implementation Tasks

1. `DataManager` — add `themeStyle` property
2. `Scene.swift` — add 6 new scenes
3. `SceneAnimationView` — add `progress` + `celebrating` params; update all 8 existing + add 6 new
4. `HomeView` — dual-theme UI + long-press switch + orb background canvas
5. `SceneCardView` — theme-aware styling
6. `FocusView` — pass `progress` to animation
7. `CompletionView` — pass `celebrating: true` + scene burst
8. Functional verification pass

---

## Apple Design Principles Applied

- **Depth** — layered materials (ultraThinMaterial, regularMaterial)
- **Clarity** — generous spacing, SF Rounded, clear hierarchy
- **Deference** — UI steps back during focus; animation IS the content
- **Continuity** — progress animation creates narrative arc

