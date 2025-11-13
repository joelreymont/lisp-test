# Common Lisp 3D Graphics Ecosystem

## Game Engines (Ready to Use)

### Trial
- **URL**: https://github.com/Shirakumo/trial
- **Type**: Full 3D game engine
- **Status**: Active development
- **Features**:
  - Entity-component-system architecture
  - Asset management and pipeline
  - Scene graph with spatial partitioning
  - Physics integration (cl-fond)
  - Audio support
  - Cross-platform (macOS, Linux, Windows)
  - OpenGL 3.3+ backend
- **Best for**: Serious game development

### Trivial Gamekit
- **URL**: https://github.com/borodust/trivial-gamekit
- **Type**: Simple 2D game framework
- **Features**: Easy to learn, quick prototyping
- **Best for**: 2D games, learning

## Low-Level Graphics Libraries

### cl-opengl
- **URL**: https://github.com/3b/cl-opengl
- **Purpose**: OpenGL bindings (up to OpenGL 4.6)
- **Coverage**: Complete OpenGL API
- **Quality**: Well-maintained, stable

### cl-sdl2
- **URL**: https://github.com/lispgames/cl-sdl2
- **Purpose**: SDL2 bindings for windowing, input, audio
- **Status**: Maintained by lispgames community
- **Cross-platform**: macOS, Linux, Windows

### cl-glfw3
- **URL**: https://github.com/AlexCharlton/cl-glfw3
- **Purpose**: Alternative to SDL2 for windowing
- **Features**: Lightweight, modern

### CEPL
- **URL**: https://github.com/cbaggers/cepl
- **Purpose**: Lispy GPU programming framework
- **Features**:
  - S-expression based shader language
  - Live coding friendly
  - Type-safe GPU data pipelines
- **Best for**: Creative coding, graphics experimentation

## Math Libraries

### 3d-vectors / 3d-matrices
- **URL**: https://github.com/Shinmera/3d-vectors
- **Purpose**: Vector and matrix math
- **Features**: Optimized, well-documented

### mathkit / rtg-math
- **Purpose**: Real-time graphics math
- **Features**: Game-focused utilities

## Physics Engines

### cl-fond
- Integration with Trial
- 3D physics

### squirl
- 2D physics (Chipmunk bindings)

## Asset Loading

### cl-soil
- Image loading (textures)

### classimp
- 3D model loading (Assimp bindings)
- Supports: OBJ, FBX, COLLADA, glTF, etc.

## Audio

### cl-openal
- OpenAL bindings
- 3D positional audio

### cl-mixer (SDL2 mixer)
- Simpler audio playback

## Development Tools

### Quicklisp
- Package manager for Common Lisp libraries
- All major libraries available via Quicklisp

### SLIME/Sly
- Interactive development environments
- Live coding support

## Recommended Stack for Building from Scratch

### Option A: Modern OpenGL
```
cl-sdl2      → Windowing & input
cl-opengl    → Graphics API
3d-vectors   → Math
3d-matrices  → Transformations
cl-soil      → Texture loading
classimp     → Model loading
cl-openal    → Audio
```

### Option B: Use Trial
- Everything integrated
- Just focus on your game logic

## Cross-Platform Considerations

### Works Well:
- Linux: Best support, easiest setup
- macOS: Good support, may need specific OpenGL context setup
- Windows: Works, SBCL recommended

### System Dependencies:
- SDL2 library (install via package manager)
- OpenGL drivers
- OpenAL (for audio)

### Installation Example (Ubuntu/Debian):
```bash
apt-get install libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev
apt-get install libopenal-dev
apt-get install libglew-dev
```

### macOS:
```bash
brew install sdl2 sdl2_image sdl2_mixer
brew install openal-soft
```

## Community Resources

- **Lispgames Wiki**: https://github.com/lispgames/lispgames.github.io
- **Trial Documentation**: Comprehensive tutorials
- **CEPL Examples**: Great for learning GPU concepts
- **Common Lisp Cookbook**: Game development section

## Success Stories

- Several shipped games using Trial
- Active game jam participation
- Demo scene productions
- Academic projects in graphics/AI

## Conclusion

**For your use case (cross-platform 3D, macOS + Linux + Windows):**

1. **Trial** is your best bet for a complete engine
2. **cl-opengl + cl-sdl2** if you want to build from components
3. **CEPL** if you want to experiment with shaders and GPU programming

All options support your target platforms well.
