# Common Lisp 3D Graphics Examples

This repository demonstrates 3D graphics programming in Common Lisp, from low-level OpenGL to high-level game engines.

## Contents

1. **`GRAPHICS-ECOSYSTEM.md`** - Comprehensive overview of available libraries and engines
2. **`rotating-cube.lisp`** - Working 3D OpenGL demo with a rotating colored cube
3. **`fibonacci-benchmark.lisp`** - Performance demonstration of SBCL optimizations
4. **`disassemble-comparison.lisp`** - Assembly-level proof of unboxing

## Quick Start: 3D Graphics

### Prerequisites

#### System Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get install sbcl libsdl2-dev libglew-dev
```

**macOS:**
```bash
brew install sbcl sdl2 glew
```

**Windows:**
- Install SBCL from http://sbcl.org/
- Download SDL2 development libraries
- Set up paths appropriately

#### Quicklisp (Common Lisp Package Manager)

If you don't have Quicklisp installed:

```bash
# Download and install Quicklisp
curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --quit

# Add to your ~/.sbclrc to load Quicklisp automatically
echo '(load "~/quicklisp/setup.lisp")' >> ~/.sbclrc
```

### Running the Rotating Cube Demo

```bash
sbcl
```

Then in the SBCL REPL:

```lisp
;; Load required libraries (first time only - will download dependencies)
(ql:quickload '(:cl-opengl :cl-sdl2))

;; Load the demo
(load "rotating-cube.lisp")

;; Run it!
(rotating-cube:run)
```

**Controls:**
- ESC - Quit the demo

You should see a colorful rotating cube with each face in a different color.

## Building from Components vs Using an Engine

### Option 1: Build from Components (What We Demonstrated)

**Pros:**
- Full control over every aspect
- Learn graphics programming deeply
- Lightweight, minimal dependencies
- Good for specialized applications

**Cons:**
- More work to set up
- Need to implement common features yourself
- Steeper learning curve

**Stack:**
```lisp
(ql:quickload '(:cl-opengl      ; OpenGL bindings
                :cl-sdl2        ; Windowing, input, events
                :3d-vectors     ; Vector math
                :3d-matrices    ; Matrix operations
                :cl-soil        ; Texture loading
                :classimp))     ; 3D model loading
```

### Option 2: Use Trial Game Engine (Recommended for Games)

**Pros:**
- Everything integrated and working
- Focus on game logic, not plumbing
- Active development and support
- Good documentation and examples

**Cons:**
- Larger dependency tree
- Less control over low-level details
- Learning the framework's way of doing things

**Quick Start with Trial:**

```lisp
;; Install Trial
(ql:quickload :trial)

;; Create a simple scene
(defclass my-scene (trial:scene)
  ())

(defmethod trial:setup-scene ((scene my-scene))
  ;; Add entities, lights, etc.
  )

;; Launch it
(trial:launch 'my-scene)
```

## Example: Matrix Math in Common Lisp

Our demo includes simple matrix implementations, but for serious work use libraries:

```lisp
(ql:quickload :3d-matrices)

;; Create a perspective projection matrix
(let ((projection (3d-matrices:mperspective 45.0 (/ 16.0 9.0) 0.1 100.0)))
  ;; Use it...
  )
```

## Cross-Platform Considerations

### Linux
- Best support
- OpenGL 3.3+ typically available
- Easy dependency installation

### macOS
- Good support
- Note: macOS deprecated OpenGL (stuck at 4.1)
- Consider using Metal bindings for future projects
- Everything in this demo works fine on current macOS

### Windows
- Fully supported
- SBCL works well on Windows
- May need to manually set up SDL2 DLLs

## Performance Notes

Common Lisp can achieve near-C performance for graphics code when properly optimized:

1. **Use type declarations** (see `fibonacci-benchmark.lisp`)
2. **Compile with `(optimize (speed 3) (safety 0))`** for critical loops
3. **SBCL** compiles to native code
4. **Profile with `sb-sprof`** to find bottlenecks

## Next Steps

### For Learning:
1. Modify the cube demo to add textures
2. Implement camera controls
3. Load 3D models with classimp
4. Add lighting calculations in shaders

### For Game Development:
1. Try Trial: https://github.com/Shirakumo/trial
2. Follow Trial's tutorials
3. Join the Shirakumo Discord for support

### For Graphics Programming:
1. Try CEPL for live-coded shaders
2. Experiment with compute shaders
3. Implement post-processing effects

## Resources

- **Lispgames Wiki**: https://github.com/lispgames/lispgames.github.io
- **Trial Documentation**: https://github.com/Shirakumo/trial/wiki
- **LearnOpenGL.com**: Excellent OpenGL tutorials (translate to Lisp!)
- **#lispgames on Libera.Chat**: IRC channel
- **Shirakumo Discord**: Active community

## Why Common Lisp for Graphics?

1. **Interactive Development**: Modify code while the game runs
2. **REPL-Driven**: Test functions immediately
3. **Powerful Macros**: Create domain-specific languages
4. **Stability**: Mature, standardized language
5. **Performance**: Compiles to native code
6. **Live Coding**: Great for creative coding and demos

## Repository Structure

```
lisp-test/
├── README.md                      # This file
├── GRAPHICS-ECOSYSTEM.md          # Detailed library overview
├── rotating-cube.lisp             # 3D OpenGL demo
├── fibonacci-benchmark.lisp       # Performance examples
└── disassemble-comparison.lisp    # Compiler optimization proof
```

## Contributing

This is a demonstration repository. Feel free to fork and experiment!

## License

Public domain / CC0 - use however you like.

---

**Questions?** The Common Lisp community is friendly and helpful. Try:
- r/lisp on Reddit
- #lisp or #lispgames on Libera.Chat IRC
- Shirakumo's Discord server
