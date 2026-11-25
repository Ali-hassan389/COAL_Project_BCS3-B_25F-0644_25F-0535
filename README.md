# 🟥 SUPER MARIO ENGINE

### A 16-bit platform adventure built instruction by instruction

<p align="center">
<strong>NASM</strong> · <strong>x86 Real Mode</strong> · <strong>DOSBox</strong> · <strong>VGA Mode 13h</strong>
</p> <p align="center">
  <img src="https://img.shields.io/badge/Platform-DOSBox-8B0000?style=for-the-badge" alt="Platform: DOSBox">
  <img src="https://img.shields.io/badge/Language-x86%20Assembly-C00000?style=for-the-badge" alt="Language: x86 Assembly">
  <img src="https://img.shields.io/badge/Assembler-NASM-17365D?style=for-the-badge" alt="Assembler: NASM">
  <img src="https://img.shields.io/badge/Display-VGA%20320%C3%97200-2E7D32?style=for-the-badge" alt="Display: VGA 320 by 200">
</p>

![Animated Mario running](https://github.com/Kageetai/mario-background-parallax/raw/refs/heads/master/img/mario.gif)

<p align="center"><em>Move fast. Think low-level. Make every pixel count.</em>
<sub>Animated visual loaded remotely from GitHub — no image upload required.</sub></p>

> **Super Mario Engine** is a retro platform game written in 16-bit x86 Assembly. There is no graphics library, no game engine and no high-level runtime: the screen, sprites, physics, enemies, collisions, menus and timing are all built from low-level procedures.

---

## ✦ Game Identity

<table>
<tr>
    <td>🏃 <strong>RUN</strong></td>
    <td>🦘 <strong>JUMP</strong></td>
    <td>💥 <strong>STOMP</strong></td>
    <td>🪙 <strong>COLLECT</strong></td>
    <td>❤️ <strong>SURVIVE</strong></td>
    <td>🏁 <strong>WIN</strong></td>
  </tr>
</table> <p align="center"><strong>Arcade energy:</strong> run · jump · collect · stomp · repeat</p>

The game recreates the core feel of a classic side-scrolling platformer:

- Explore a multi-screen level with scrolling camera movement.

- Jump beneath question blocks and bricks.

- Collect coins and mushrooms.

- Stomp Goombas and kick Koopa shells.

- Grow from Small Mario into Super Mario.

- Reach the flag before time and lives run out.

- Watch score events appear above the action through animated score pop-ups.

---

## 🎮 Feature Deck

| System | Included |
| --- | --- |
| VGA Mode 13h, 320×200, 256 colours | ✅ |
| Off-screen frame buffer rendering | ✅ |
| Shared parameter-driven bitmap renderer | ✅ |
| Smooth camera scrolling | ✅ |
| Acceleration, friction and variable jump height | ✅ |
| Goomba records and generic update logic | ✅ |
| Koopa Troopa and shell behaviour | ✅ |
| Question blocks, used blocks and breakable bricks | ✅ |
| Coins and mushroom power-up | ✅ |
| Small Mario / Super Mario forms | ✅ |
| Score, coins, lives, health and timer HUD | ✅ |
| Title, pause, dying, life-lost, completion and Game Over screens | ✅ |
| Animated walking frames | ⭐ Bonus |
| Floating score pop-ups | ⭐ Bonus |
| Sound effects | Planned extension |

---

## 🕹️ Controls

### Title screen

| Key | Action |
| --- | --- |
| `↑` / `↓` | Move through the menu |
| `Enter` | Select START GAME or EXIT |

### Gameplay

| Key | Action |
| --- | --- |
| `←` | Move left |
| `→` | Move right |
| `Shift` | Run / increase movement speed |
| `Space` | Jump; hold for a higher jump |
| `P` | Pause / resume |
| `Esc` | Return to title or exit according to the current state |

> The keyboard is handled by a custom interrupt routine. Key states are stored independently, allowing combinations such as **Right + Shift + Space**.

---

## 🧱 World Systems

### Hero forms

- **Small Mario** starts with one health state.

- Collecting a mushroom changes Mario into **Super Mario**.

- Enemy contact as Super Mario removes the power-up and returns Mario to Small Mario.

- Enemy contact as Small Mario begins the death sequence.

### Enemies

- **Goomba:** record-based walking enemy with direction, speed, bounds and stomp state.

- **Koopa Troopa:** walking enemy with shell conversion, shell sliding, shell kicking and shell-versus-Goomba interaction.

### Interactive objects

- Question blocks release coins or mushrooms.

- Used question blocks remain solid after activation.

- Super Mario can break bricks and earn points.

- Pipes, stairs, platforms, pits and the flag are part of the collision world.

### Score pop-ups ⭐ Bonus

Scoring events are routed through a shared score system. When an event occurs, the score is updated and a floating popup record is created with:

- World X coordinate

- World Y coordinate

- Score value

- Remaining display frames

The popup rises above the action while fading from the active game scene, giving the game a more modern arcade feel without requiring a separate text engine.

### Walking animation ⭐ Bonus

Mario’s movement animation is controlled by `animTimer`. While walking, the timer advances and selects the appropriate standing or walking sprite. The animation is integrated with movement rather than being a separate rendering pass, keeping the game loop compact and responsive.

---

## ⚙️ Technical Profile

| Specification | Value |
| --- | --- |
| CPU model | 16-bit x86 real mode |
| Program format | DOS `.COM` |
| Entry point | `ORG 100h` |
| Assembler | NASM |
| Emulator | DOSBox v0.74-3 or later |
| Video mode | VGA Mode 13h |
| Resolution | 320×200 |
| Colour depth | 256 indexed colours |
| Video memory | `A000h` |
| Physics | Integer and 8.8 fixed-point values |
| Frame rendering | Off-screen buffer → video memory |
| Current executable | `MARIO.COM` |
| Current executable size | 18,159 bytes |
| Assembly source count | 6,163 lines |

### Memory strategy

A `.COM` program shares one segment for its code, data and stack. The game therefore reserves external DOS memory for two graphics buffers:

1. A 64,000-byte off-screen frame buffer.

1. A 64,000-byte saved-background buffer used by visual sequences.

At startup, the program retains a sufficiently large DOS memory block and allocates both buffers through `INT 21h`. The frame is assembled away from the visible screen and copied to video memory once per frame to reduce flicker.

---

## 🧩 Project Architecture

```
Mario_game/
├── MARIO.COM                 # Built DOS executable
├── build.bat                 # NASM build command
├── README.md                 # This guide
│
├── source/
│   ├── mario.asm             # COM entry point and game-state dispatcher
│   ├── include/
│   │   └── const.inc         # Shared constants and game limits
│   │
│   ├── gfx/                  # Abdur Rehman Naseer
│   │   ├── drw.asm           # Shared bitmap drawing and clipping
│   │   ├── gfx_vid.asm       # VGA mode and frame-buffer output
│   │   ├── margfx.asm        # Mario sprites
│   │   ├── googfx.asm        # Goomba sprites
│   │   ├── trtegfx.asm       # Koopa sprites
│   │   ├── blkgfx.asm        # Question and used blocks
│   │   ├── brkgfx.asm        # Brick sprites
│   │   ├── coingfx.asm       # Coin sprites
│   │   ├── pipegfx.asm       # Pipe sprites
│   │   ├── shrmgfx.asm       # Mushroom sprites
│   │   ├── stairgfx.asm      # Stair sprites
│   │   └── colors.inc        # Palette constants
│   │
│   ├── level/                # Abdur Rehman Naseer
│   │   ├── level.asm         # Main level content and rendering
│   │   ├── level2.asm        # Additional world objects
│   │   └── level3.asm        # Additional world objects and rows
│   │
│   ├── mech/                 # Ali Hassan
│   │   ├── camera.asm        # Camera scrolling
│   │   ├── coll.asm          # Generic collision and wall resolution
│   │   ├── coin.asm          # Coin entities
│   │   ├── coin2.asm         # Additional coin entities
│   │   ├── game.asm          # Reset logic and game flow
│   │   ├── goomba.asm        # Generic Goomba records and updates
│   │   ├── input.asm         # Keyboard interrupt and movement input
│   │   ├── move.asm          # Mario physics and movement
│   │   ├── score.asm         # Score, popups and scoring events
│   │   ├── shroom.asm        # Mushroom movement and collection
│   │   ├── timer.asm         # Timer interrupt and game clock
│   │   └── turtle.asm        # Koopa and shell behaviour
│   │
│   └── ui/                   # Ali Hassan
│       ├── Hud.asm           # Score, lives, health, coins and time
│       ├── font.asm          # 3×5 font and text rendering
│       ├── text.asm          # Text helpers
│       ├── start.asm         # Title screen
│       ├── pause.asm         # Pause screen
│       ├── life.asm          # Life-lost screen
│       ├── over.asm          # Game Over screen
│       └── comple.asm        # Level-complete screen
│
└── tools/
    ├── nasm.exe              # Bundled NASM executable
    └── AFD.EXE               # DOS assembly debugger
```

---

## 🧠 Core Engineering Decisions

### One renderer, many sprites

`DrawBitmapSprite` accepts sprite data and rendering parameters through the stack:

```
sprite address
transparent colour
height
width
Y coordinate
X coordinate
```

The same helper is reused for blocks, bricks, coins, Goombas, mushrooms, pipes, stairs, Koopas, Mario and title-screen entities. It also clips sprites at all four screen boundaries.

### Generic collision routines

Instead of writing separate collision algorithms for every object, collision helpers receive coordinates and state data as parameters. Compatibility wrappers preserve existing labels while the actual collision decision is shared.

### Record-driven enemies

Enemy state is stored in compact records. Generic procedures use indexed offsets such as:

```
G_ACTIVE · G_X · G_Y · G_DIR · G_SPEED · G_TIMER
K_ACTIVE · K_DIR · K_X · K_Y · K_MINX · K_MAXX · K_TIMER
```

This keeps Goomba and Koopa updates consistent and makes additional enemies easier to add.

### State-machine screens

The main loop dispatches through a state table:

```
TITLE → PLAYING → PAUSED → PLAYING
                  ↓
                DYING → LIFE LOST → PLAYING
                  ↓
              GAME OVER → TITLE

PLAYING → WIN → LEVEL COMPLETE → TITLE
```

---

## 🚀 Build and Run

### Option A — Build with the bundled DOS NASM

Open DOSBox and mount the project directory:

```
MOUNT C /path/to/Mario_game
C:
CD Mario_game
BUILD.BAT
MARIO.COM
```

### Option B — Build with native NASM

From the project directory:

```bash
nasm -f bin source/mario.asm -o MARIO.COM
```

Then launch `MARIO.COM` inside DOSBox.

### Suggested DOSBox setup

```
mount c /path/to/Mario_game
c:
MARIO.COM
```

For debugging with AFD:

```
mount c /path/to/Mario_game
c:
AFD MARIO.COM
```

> Use DOSBox v0.74-3 or later. The game expects a VGA-compatible DOS environment and restores text mode when it exits cleanly.

---

## 🔄 Main Frame Pipeline

![Mario running animation loaded from GitHub](https://github.com/Kageetai/mario-background-parallax/raw/refs/heads/master/img/mario.gif)

The animation above is loaded from a public GitHub raw file, so this repository does not need to store or upload an image asset. Under the hood, every frame still follows the pipeline below: input, update, collide, draw and present.

```
┌──────────────────────┐
│ Read keyboard state  │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Update timer / clock  │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Mario physics        │
│ gravity + velocity   │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Generic collisions   │
│ blocks + enemies     │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Update Goombas,      │
│ Koopas, coins, items │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Update camera        │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Draw world + sprites │
│ + HUD + popups       │
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│ Present frame buffer │
└──────────────────────┘
```

---

## 🏆 Scoring Events

| Event | Result |
| --- | --- |
| Collect coin | Score increases and coin count updates |
| Stomp Goomba | Score popup appears above the enemy |
| Kick Koopa shell | Shell state changes and score is awarded |
| Shell defeats Goomba | Additional score popup |
| Collect mushroom | Mario becomes Super Mario |
| Break brick as Super Mario | Brick disappears and score is awarded |
| Touch flag | Level completion and time bonus |
| Finish with remaining time | Time converts into bonus score |

---

## 👥 Team Ownership

| Contributor | Roll number | Ownership |
| --- | --- | --- |
| **Ali Hassan** | `25F-0644` | `source/mech` and `source/ui`: game logic, physics, collisions, input, enemies, score, HUD and screens |
| **Abdur Rehman Naseer** | `25F-0644` | `source/gfx` and `source/level`: sprites, bitmap rendering, VGA support and level content |

Integration was performed through shared constants, common stack conventions, state records and the main `.COM` entry point.

---



## 📜 Credits

**Super Mario Engine**
EL2003 — Computer Organization and Assembly Language
National University of Computer & Emerging Sciences — Chiniot-Faisalabad Campus

**Team**

- Ali Hassan — `25F-0644`

- Abdur Rehman Naseer — `25F-0644`

Built with assembly, pixels and patience.

Animated README visual: [Mario animation source repository](https://github.com/Kageetai/mario-background-parallax), loaded through its raw GitHub asset URL.

---

<p align="center">
<strong>START GAME</strong> · <strong>KEEP MOVING</strong> · <strong>REACH THE FLAG</strong>
</p>
