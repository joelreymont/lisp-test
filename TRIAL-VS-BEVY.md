# Trial vs Bevy: A Comprehensive Comparison

Both Trial (Common Lisp) and Bevy (Rust) are modern, ECS-based game engines with strong technical foundations but very different philosophies.

## Quick Reference Table

| Feature | Trial (Common Lisp) | Bevy (Rust) |
|---------|-------------------|-------------|
| **Language** | Common Lisp (SBCL) | Rust |
| **First Release** | ~2017 | 2020 |
| **Architecture** | Entity-Component System | Entity-Component System |
| **License** | zlib | MIT/Apache 2.0 |
| **GitHub Stars** | ~400 | ~36,000+ |
| **Development Style** | REPL-driven, interactive | Compile-time, type-safe |
| **Visual Editor** | Build your own | Planned (in development) |
| **Hot Reload** | Native (REPL) | Assets only |
| **Compile Times** | Near-instant (interpreted + JIT) | 0.8-3s (fast config), longer for full builds |
| **Community Size** | Small, specialized | Large, rapidly growing |
| **Learning Curve** | Steep (Common Lisp) | Moderate (Rust + ECS) |
| **Production Games** | Kandria, Eternia | Many indie titles |
| **Cross-Platform** | Win/Mac/Linux | Win/Mac/Linux/Web/Mobile/VR |

---

## Language & Ecosystem

### Trial (Common Lisp)
**Strengths:**
- **Interactive development**: Modify running code in real-time via REPL
- **Mature language**: ANSI Common Lisp standard from 1994, extremely stable
- **Powerful macros**: Create DSLs tailored to your game
- **Near-instant compilation**: SBCL compiles incrementally, no long build times
- **Dynamic typing with optional static declarations**: Flexibility + performance when needed
- **Image-based development**: Save entire runtime state, restart exactly where you left off

**Weaknesses:**
- **Small ecosystem**: Fewer libraries compared to Rust/C++
- **Smaller community**: Harder to find help, fewer tutorials
- **Learning curve**: Common Lisp syntax and idioms are unfamiliar to most
- **Fewer job opportunities**: Not a mainstream language

### Bevy (Rust)
**Strengths:**
- **Modern language**: Rust's safety guarantees prevent entire classes of bugs
- **Growing ecosystem**: Cargo has thousands of high-quality crates
- **Large community**: Active Discord, many tutorials, strong momentum
- **Industry relevance**: Rust skills are marketable
- **Compile-time guarantees**: Catch bugs before running
- **Memory safety without GC**: No garbage collection pauses

**Weaknesses:**
- **Compilation times**: Even with "fast compiles", rebuilds take seconds to minutes
- **Strict borrow checker**: Fight with the compiler until you understand ownership
- **No runtime introspection**: Can't inspect/modify types as easily as Lisp
- **Still evolving**: Breaking API changes every ~3 months
- **Steeper initial learning curve**: Rust concepts (ownership, lifetimes) take time

---

## Architecture & Design

### Both Use ECS (Entity-Component-System)

**Trial ECS:**
- Loose coupling of components
- Class-based entities (CLOS - Common Lisp Object System)
- Multiple dispatch for systems
- Flexible, Lispy approach
- Less focus on optimal data layout

**Bevy ECS:**
- Archetype-based storage (data-oriented design)
- Highly optimized for cache coherency
- Parallel system execution (uses Rust's Rayon)
- Compile-time validated queries
- Focused on maximum performance

**Performance:**
- **Bevy**: Extremely fast, designed to scale to millions of entities
- **Trial**: Fast enough for most games, but not as aggressively optimized as Bevy
- **Common Lisp**: Can achieve C-like performance with type declarations
- **Rust**: Near-C performance by default

---

## Development Workflow

### Trial: REPL-Driven Development

```lisp
;; Start the game
(trial:launch 'my-game)

;; While the game is running, modify code:
(defmethod update ((entity player) dt)
  (incf (location entity) (vec 1 0 0)))  ; Changes apply immediately

;; Inspect state
(find-entity 'player *scene*)
(location *)  ; Check player position

;; Modify at runtime
(setf (health player-entity) 100)

;; No restart needed - changes are live
```

**Workflow:**
1. Launch game once
2. Edit code in editor
3. Evaluate changes in REPL
4. See results immediately
5. Repeat

**Average iteration time:** < 1 second

### Bevy: Compile-Run-Test Cycle

```rust
// Define a system
fn move_player(mut query: Query<&mut Transform, With<Player>>, time: Res<Time>) {
    for mut transform in &mut query {
        transform.translation.x += 100.0 * time.delta_seconds();
    }
}

// Make a change, recompile, restart
// cargo run
```

**Workflow:**
1. Edit code in editor
2. Run `cargo run` (recompile)
3. Restart game
4. Test changes
5. Repeat

**Average iteration time:** 0.8-10 seconds (depending on change scope)

**Note:** Bevy supports hot-reloading of *assets* (textures, models, shaders), but not code.

---

## Tooling & Editor

### Trial
- **No official visual editor**
- **SLIME/Sly**: Powerful Emacs/Vim integration for interactive development
- **Build your own tools**: Framework for creating in-game editors (see Kandria)
- **Debugging**: Full REPL access, inspect anything at runtime
- **Profiling**: `sb-sprof` for SBCL profiling

**Philosophy:** Code IS the editor. Use the REPL.

### Bevy
- **Official editor in development** (Bevy Editor, not released yet)
- **Third-party editors**: `bevy_editor_pls`, `space_editor`
- **Standard Rust tooling**: `cargo`, `rust-analyzer` for IDE support
- **Debugging**: Standard debuggers (gdb, lldb) + Rust's excellent error messages
- **Profiling**: Tracy, puffin, built-in diagnostic tools

**Philosophy:** Editor coming, but code-first for now.

---

## Cross-Platform Support

### Trial
- ✅ Windows
- ✅ macOS (OpenGL 4.1 limit due to deprecation)
- ✅ Linux
- ❌ Web (theoretically possible with CL-WASM, not production-ready)
- ❌ Mobile (not officially supported)
- ❌ Consoles (no support)

**Graphics:** OpenGL 3.3+

### Bevy
- ✅ Windows
- ✅ macOS (Metal backend available)
- ✅ Linux
- ✅ Web (WebAssembly + WebGL/WebGPU)
- ✅ Mobile (Android, iOS - experimental)
- ✅ VR (basic support)
- ⚠️ Consoles (community efforts, not official)

**Graphics:** wgpu (abstraction over Vulkan/Metal/DX12/WebGPU/OpenGL)

**Winner:** Bevy has significantly broader platform support.

---

## Community & Resources

### Trial
- **Community Size:** Small (~400 GitHub stars)
- **Documentation:** Comprehensive docs at shirakumo.org/docs/trial
- **Tutorials:** Limited, mostly from Shinmera (the author)
- **Support:** #shirakumo on Libera.Chat IRC, Discord
- **Production games:** Kandria (shipped on Steam), Eternia

**Pros:** Tight-knit, helpful community
**Cons:** Smaller resource pool, fewer examples

### Bevy
- **Community Size:** Large (~36,000 GitHub stars)
- **Documentation:** Extensive official docs + community guides
- **Tutorials:** Many tutorials, YouTube videos, blog posts
- **Support:** Very active Discord, forums, Reddit r/bevy
- **Production games:** Dozens of shipped indie games

**Pros:** Easy to find help, lots of examples
**Cons:** Can be overwhelming, API changes frequently

**Winner:** Bevy has a massively larger community.

---

## Performance Characteristics

### Trial (Common Lisp / SBCL)

**Pros:**
- Compiles to native code (via SBCL)
- Can achieve C-like performance with type declarations
- Minimal overhead for simple games
- GC is generational and fast for most use cases
- Live profiling without restarting

**Cons:**
- Garbage collection pauses (though usually <1ms)
- Requires manual optimization (type declarations)
- Not as aggressively optimized as Bevy's ECS
- Dynamic dispatch can be slower than Rust's static dispatch

**Typical performance:** 60 FPS easily for 2D, good 3D performance for modest scenes

### Bevy (Rust)

**Pros:**
- Extremely fast ECS (archetype-based, cache-friendly)
- Zero-cost abstractions
- No garbage collection
- Parallel system execution by default
- Data-oriented design for maximum throughput
- Scales to millions of entities

**Cons:**
- Compilation time impacts iteration speed
- Debug builds are slower (release builds are very fast)

**Typical performance:** 60+ FPS for complex 3D scenes, 2D is blazing fast

**Benchmark note:** Bevy is 2x faster than Godot for 2D rendering, can handle massive entity counts.

**Winner:** Bevy is faster out-of-the-box for demanding games.

---

## Learning Curve

### Trial
**Prerequisites:**
- Learn Common Lisp (syntax, macros, CLOS)
- Understand REPL workflow
- Learn graphics fundamentals (OpenGL)
- Understand Trial's architecture

**Time to productivity:**
- If you know Common Lisp: ~1-2 weeks
- If you're new to Lisp: ~2-3 months

**Challenges:**
- Parentheses (minor, you get used to it)
- Macro system (powerful but takes time)
- Different way of thinking (interactive vs batch)

### Bevy
**Prerequisites:**
- Learn Rust (ownership, borrowing, lifetimes)
- Understand ECS architecture
- Learn Bevy's specific APIs

**Time to productivity:**
- If you know Rust: ~1-2 weeks
- If you're new to Rust: ~1-2 months

**Challenges:**
- Fighting the borrow checker initially
- ECS mindset (if coming from OOP)
- Frequent breaking changes

**Winner:** Bevy is slightly easier due to more resources, but both have learning curves.

---

## Unique Strengths

### Trial's Killer Features

1. **Live Coding**
   - Modify shaders, game logic, entities while the game runs
   - No compilation delay
   - Incredible for creative experimentation

2. **Image-Based Development**
   - Save entire game state to disk
   - Restart exactly where you left off
   - Debugging heaven

3. **Lisp Macros**
   - Create domain-specific languages
   - Generate code programmatically
   - Extremely powerful metaprogramming

4. **Stability**
   - Common Lisp standard hasn't changed in 30+ years
   - Code written for Trial today will work in 10 years

5. **REPL as IDE**
   - Inspect anything, anywhere, anytime
   - No special debugging mode needed

### Bevy's Killer Features

1. **Data-Oriented Design**
   - ECS is optimized for cache coherency
   - Scales to massive entity counts
   - Parallel by default

2. **Modern Graphics**
   - wgpu backend (Vulkan/Metal/DX12)
   - Render graphs for complex effects
   - WebGPU support

3. **Broad Platform Support**
   - Web, mobile, desktop out of the box
   - Single codebase for all platforms

4. **Memory Safety**
   - No null pointer crashes
   - No use-after-free
   - Rust catches bugs at compile time

5. **Active Development**
   - New features every 3 months
   - Large contributor base
   - Funded development

---

## Use Case Recommendations

### Choose Trial If:
- ✅ You value interactive development above all else
- ✅ You're comfortable with Lisp (or want to learn it)
- ✅ You're making a PC game (Win/Mac/Linux)
- ✅ You want to build custom tools/editor
- ✅ You enjoy metaprogramming and DSLs
- ✅ You prefer a stable, unchanging API
- ✅ You're doing creative coding / experimental work
- ✅ Team size: Solo or small team

**Example games:** 2D platformers, puzzle games, narrative games, roguelikes

### Choose Bevy If:
- ✅ You need maximum performance (lots of entities)
- ✅ You want broad platform support (especially web/mobile)
- ✅ You're comfortable with Rust (or want to learn it)
- ✅ You want a large community and resources
- ✅ You value compile-time safety
- ✅ You need cutting-edge graphics features
- ✅ You're okay with API changes
- ✅ Team size: Any size

**Example games:** Action games, shooters, sims with thousands of entities, mobile games

---

## Code Comparison

### Creating a Bouncing Square

**Trial (Common Lisp):**

```lisp
(define-shader-entity square (vertex-entity colored-entity)
  ((vertex-array :initform (// 'trial:trial 'trial::unit-square))
   (color :initarg :color :accessor color)))

(define-handler (square tick) (dt)
  (let ((pos (location square)))
    (incf (vy pos) (* -9.8 dt))  ; Gravity
    (when (< (vy pos) 0)
      (setf (vy pos) (* -0.8 (vy pos))))))  ; Bounce

;; In REPL:
(enter (make-instance 'square :location (vec 100 200)
                               :color (vec 1 0 0))
       *scene*)
```

**Bevy (Rust):**

```rust
#[derive(Component)]
struct Square;

#[derive(Component)]
struct Velocity(Vec2);

fn spawn_square(mut commands: Commands) {
    commands.spawn((
        SpriteBundle {
            sprite: Sprite { color: Color::RED, ..default() },
            transform: Transform::from_xyz(100.0, 200.0, 0.0),
            ..default()
        },
        Square,
        Velocity(Vec2::ZERO),
    ));
}

fn bounce_system(
    mut query: Query<(&mut Transform, &mut Velocity), With<Square>>,
    time: Res<Time>,
) {
    for (mut transform, mut velocity) in &mut query {
        velocity.0.y -= 9.8 * time.delta_seconds();  // Gravity
        transform.translation.y += velocity.0.y * time.delta_seconds();

        if transform.translation.y < 0.0 {
            velocity.0.y *= -0.8;  // Bounce
        }
    }
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, spawn_square)
        .add_systems(Update, bounce_system)
        .run();
}
```

**Observations:**
- **Trial**: More concise, immediate experimentation in REPL
- **Bevy**: More boilerplate, but explicit and type-safe

---

## Verdict: Which Should You Choose?

### Trial is for:
- **Lisp enthusiasts** who value interactive development
- **Solo developers** or small teams
- **Creative coders** who iterate constantly
- **Desktop-only** games
- Those who want a **stable, mature** foundation

### Bevy is for:
- **Rust enthusiasts** who value safety and performance
- **Teams of any size** (better tooling for collaboration)
- **Multi-platform** games (especially web/mobile)
- **Performance-critical** games
- Those who want a **growing, vibrant** ecosystem

### The Honest Answer:

**For your use case (cross-platform 3D, macOS + Linux + Windows):**

If you're learning or building a serious game to ship commercially, **Bevy** is probably the better choice:
- Broader platform support (web especially)
- Larger community for help
- Better long-term prospects
- More resources and examples

**However**, if you:
- Really value interactive development
- Are passionate about Lisp
- Want to learn a unique approach to game dev
- Don't need web/mobile

Then **Trial** offers a truly unique development experience that's hard to match.

### My Personal Take:

Both are excellent engines. Bevy is more "pragmatic" for shipping games. Trial is more "magical" for the development experience. Try both and see which philosophy resonates with you!

---

## Resources

### Trial
- Homepage: https://shirakumo.org/docs/trial/
- Source: https://codeberg.org/shirakumo/trial
- Discord: Shirakumo server
- Example: Kandria source code

### Bevy
- Homepage: https://bevyengine.org/
- Source: https://github.com/bevyengine/bevy
- Discord: Very active
- Examples: https://bevyengine.org/examples/

---

**TL;DR:** Bevy has broader platform support, larger community, and better performance. Trial has unmatched interactive development experience. Both are excellent choices depending on your priorities.
