# Pong Clone with SDL3

An enhanced Pong clone for macOS, built with modern **C++17** and the latest **SDL3** / **SDL3_ttf** libraries. Features smooth ball physics, AI-controlled opponent with predictive trajectory tracking, adjustable difficulty levels, and on-screen scoring.

![C++17](https://img.shields.io/badge/C%2B%2B-17-blue)
![SDL3](https://img.shields.io/badge/SDL-3.2.20-green)
![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey)

---

## 🎮 Features

- **Smooth Ball Physics** — Subpixel movement using `SDL_FRect` for precise positioning
- **AI Opponent** — Predictive trajectory tracking with bounce simulation
- **Adjustable Difficulty** — Easy, Medium, and Hard modes with different AI behaviors
- **Dynamic Gameplay** — Ball speed increases on paddle hits, angle varies by hit position
- **Score Display** — Real-time score rendering with SDL3_ttf
- **Classic Visuals** — Dashed center line, clean black & white aesthetic

---

## 🕹️ Controls

| Key | Action |
|-----|--------|
| `W` / `↑` | Move paddle up |
| `S` / `↓` | Move paddle down |
| `1` | Set difficulty to Easy |
| `2` | Set difficulty to Medium |
| `3` | Set difficulty to Hard |
| `ESC` | Quit game |

---

## 📁 Project Structure

```
Pong/
├── main.cpp              # Entry point - creates and runs Game instance
├── src/
│   ├── Game.h            # Game class interface & Difficulty enum
│   ├── Game.cpp          # Full game implementation
│   ├── Ball.h            # Ball struct definition
│   └── Paddle.h          # Paddle struct definition
├── CMakeLists.txt        # CMake build configuration
├── conanfile.py          # Conan dependency manager config
├── conan_provider.cmake  # Conan CMake integration
└── README.md
```

---

## 🏗️ Architecture

### Classes & Structs

#### `Ball` ([src/Ball.h](src/Ball.h))
```cpp
struct Ball {
    SDL_FRect rect;  // Position (x, y) and size (w, h)
    float vx;        // Velocity in x direction (px/sec)
    float vy;        // Velocity in y direction (px/sec)
};
```

#### `Paddle` ([src/Paddle.h](src/Paddle.h))
```cpp
struct Paddle {
    SDL_FRect rect;  // Position and size
    float speed;     // Movement speed (px/sec)
};
```

#### `Difficulty` Enum ([src/Game.h](src/Game.h))
```cpp
enum class Difficulty { Easy, Medium, Hard };
```

#### `Game` Class ([src/Game.h](src/Game.h))
Main game manager handling initialization, game loop, rendering, and cleanup.

| Method | Description |
|--------|-------------|
| `Init()` | Initialize SDL3, TTF, window, renderer, and game objects |
| `Run()` | Main game loop - events, physics, AI, rendering |
| `SetDifficulty()` | Adjust AI paddle speed and behavior |
| `ResetBall()` | Reset ball to center with random direction |
| `UpdateAI()` | AI paddle movement with trajectory prediction |
| `PredictBallImpactX()` | Calculate where ball will intersect paddle plane |
| `UpdateScoreTexture()` | Render score text to texture |

---

## 🤖 AI System

The AI opponent uses **predictive trajectory tracking** rather than simply following the ball's current position.

### How It Works

1. **Trajectory Prediction** — Calculates where the ball will be when it reaches the AI paddle's x-coordinate
2. **Bounce Simulation** — Uses modular arithmetic to simulate wall reflections:
   ```cpp
   reflectedY = mod > h ? (2 * h - mod) : mod;
   ```
3. **Difficulty Scaling** — AI behavior varies by difficulty level:

| Difficulty | AI Speed | Reaction | Accuracy |
|------------|----------|----------|----------|
| **Easy** | 400 px/s | Waits until ball passes midfield | ±20px random offset |
| **Medium** | 640 px/s | Reacts at 30% field distance | ±10px random offset |
| **Hard** | 900 px/s | Immediate reaction | Perfect tracking |

---

## ⚡ Physics

### Ball Movement
- **Base Speed**: 520 px/sec
- **Max Speed**: 1100 px/sec
- **Speed Increase**: 5% on each paddle hit
- **Angle Range**: ±25° initial launch angle

### Paddle Deflection
The ball's outgoing angle depends on where it hits the paddle:
- **Center hit** → Shallow angle
- **Edge hit** → Steep angle (up to ~55°)

```cpp
float impactDist = (ballCenter - paddleCenter);
ball->vy += impactDist * 5.0f;  // Angle adjustment factor
```

### Collision Detection
Simple AABB (Axis-Aligned Bounding Box) collision:
```cpp
if (bl.x < pl.x + pl.w && bl.x + bl.w > pl.x &&
    bl.y < pl.y + pl.h && bl.y + bl.h > pl.y && ball->vx < 0)
```

---

## 🔧 Build Instructions

### Prerequisites

| Tool | Version | Installation |
|------|---------|--------------|
| **CMake** | 3.16+ | [cmake.org](https://cmake.org/download/) |
| **Conan** | 2.x | `pip install conan` |
| **C++17 Compiler** | — | See platform-specific below |

---

### 🍎 macOS

#### Requirements
- **Xcode Command Line Tools** or full Xcode
- **AppleClang** (included with Xcode)

```bash
# Install Xcode CLI tools (if not already installed)
xcode-select --install

# Install Conan via Homebrew (recommended)
brew install conan

# Or via pip
pip3 install conan
```

#### Build & Run

```bash
# Clone the repository
git clone <repo-url>
cd Pong

# Install dependencies (first time only)
conan install . --build=missing

# Configure with CMake
cmake --preset conan-release

# Build
cmake --build --preset conan-release

# Run the game
./build/build/Release/Pong
```

---

### 🪟 Windows

#### Requirements
- **Visual Studio 2019/2022** with "Desktop development with C++" workload
- Or **MinGW-w64** with GCC 8+

#### Option A: Visual Studio (Recommended)

```powershell
# Install Conan (via pip or standalone installer)
pip install conan

# Clone and enter directory
git clone <repo-url>
cd Pong

# Detect default profile (first time only)
conan profile detect

# Install dependencies
conan install . --build=missing -s build_type=Release

# Configure with CMake (Visual Studio generator)
cmake --preset conan-default

# Build
cmake --build --preset conan-release --config Release

# Run the game
.\build\build\Release\Pong.exe
```

#### Option B: MinGW / MSYS2

```bash
# Install MSYS2 from https://www.msys2.org/
# Open MSYS2 MinGW64 terminal

# Install required packages
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc

# Install Conan
pip install conan

# Configure Conan for MinGW
conan profile detect
# Edit ~/.conan2/profiles/default and set:
#   compiler=gcc
#   compiler.version=<your-version>

# Build steps same as macOS
conan install . --build=missing
cmake --preset conan-release
cmake --build --preset conan-release

# Run
./build/build/Release/Pong.exe
```

---

### 🐧 Linux (Bonus)

```bash
# Ubuntu/Debian - install dependencies
sudo apt update
sudo apt install build-essential cmake libgl1-mesa-dev

# Install Conan
pip3 install conan

# Build (same as macOS)
conan install . --build=missing
cmake --preset conan-release
cmake --build --preset conan-release

# Run
./build/build/Release/Pong
```

---

### 🛠️ IDE Integration

#### CLion
1. Open the project folder
2. CLion auto-detects CMake
3. Configure Conan plugin or run `conan install . --build=missing` in terminal
4. Select `conan-release` preset in CMake settings
5. Build & Run

#### Visual Studio Code
1. Install extensions: **CMake Tools**, **C/C++**
2. Run `conan install . --build=missing` in terminal
3. Select kit and preset via CMake Tools
4. Press `F5` to build and run

#### Visual Studio
1. Run `conan install . --build=missing` in Developer PowerShell
2. Open folder (CMake project support)
3. Select `conan-release` configuration
4. Build with `Ctrl+Shift+B`

---

## 📦 Dependencies

Managed via [Conan](https://conan.io/):

| Package | Version | Purpose |
|---------|---------|---------|
| `sdl` | 3.2.20 | Windowing, rendering, input |
| `sdl_ttf` | 3.2.2 | TrueType font rendering |

SDL3_ttf also brings in: Freetype, HarfBuzz, libpng, zlib, brotli

---

## 🎯 Game Constants

| Constant | Value | Description |
|----------|-------|-------------|
| Window Size | 800×600 | Default window dimensions |
| Ball Size | 16×16 px | Square ball |
| Paddle Size | 18×120 px | Paddle dimensions |
| Player Speed | 720 px/sec | Left paddle movement speed |
| Font Size | 48 px | Score text size |

---

## 📝 SDL3 Notes

This project uses **SDL3** (not SDL2), which includes several API changes:
- Functions return `bool` instead of `int` for success/failure
- Event types use `SDL_EVENT_*` prefix (e.g., `SDL_EVENT_QUIT`)
- `SDL_DestroySurface()` replaces `SDL_FreeSurface()`
- `SDL_RenderTexture()` replaces `SDL_RenderCopy()`
- `SDL_FRect` used for subpixel precision rendering
- Must include `<SDL3/SDL_main.h>` separately

---

## 📄 License

Open source - feel free to modify and extend!

---

## 🙏 Acknowledgments

- [SDL Wiki](https://wiki.libsdl.org/SDL3/) for comprehensive documentation
- [Lazy Foo' Productions](https://lazyfoo.net/tutorials/SDL3/) for SDL3 tutorials
- Hack Club for project inspiration
