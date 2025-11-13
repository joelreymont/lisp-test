;;;; Rotating 3D Cube Demo using cl-opengl and cl-sdl2
;;;; Demonstrates foundational libraries for 3D graphics in Common Lisp

(defpackage :rotating-cube
  (:use :cl)
  (:export :run))

(in-package :rotating-cube)

;;; This demo requires:
;;; - cl-opengl (OpenGL bindings)
;;; - cl-sdl2 (SDL2 bindings for windowing)
;;;
;;; Install with Quicklisp:
;;; (ql:quickload '(:cl-opengl :cl-sdl2))
;;;
;;; System dependencies (install before running):
;;; Ubuntu/Debian: apt-get install libsdl2-dev libglew-dev
;;; macOS: brew install sdl2 glew

;;; ============================================================================
;;; Cube Geometry (vertices with colors)
;;; ============================================================================

(defparameter *cube-vertices*
  #(;; Front face (red)
    -0.5 -0.5  0.5   1.0 0.0 0.0
     0.5 -0.5  0.5   1.0 0.0 0.0
     0.5  0.5  0.5   1.0 0.0 0.0
    -0.5  0.5  0.5   1.0 0.0 0.0

    ;; Back face (green)
    -0.5 -0.5 -0.5   0.0 1.0 0.0
     0.5 -0.5 -0.5   0.0 1.0 0.0
     0.5  0.5 -0.5   0.0 1.0 0.0
    -0.5  0.5 -0.5   0.0 1.0 0.0

    ;; Top face (blue)
    -0.5  0.5 -0.5   0.0 0.0 1.0
    -0.5  0.5  0.5   0.0 0.0 1.0
     0.5  0.5  0.5   0.0 0.0 1.0
     0.5  0.5 -0.5   0.0 0.0 1.0

    ;; Bottom face (yellow)
    -0.5 -0.5 -0.5   1.0 1.0 0.0
     0.5 -0.5 -0.5   1.0 1.0 0.0
     0.5 -0.5  0.5   1.0 1.0 0.0
    -0.5 -0.5  0.5   1.0 1.0 0.0

    ;; Right face (magenta)
     0.5 -0.5 -0.5   1.0 0.0 1.0
     0.5  0.5 -0.5   1.0 0.0 1.0
     0.5  0.5  0.5   1.0 0.0 1.0
     0.5 -0.5  0.5   1.0 0.0 1.0

    ;; Left face (cyan)
    -0.5 -0.5 -0.5   0.0 1.0 1.0
    -0.5 -0.5  0.5   0.0 1.0 1.0
    -0.5  0.5  0.5   0.0 1.0 1.0
    -0.5  0.5 -0.5   0.0 1.0 1.0
    )
  "Vertex positions (x,y,z) and colors (r,g,b) for a cube")

(defparameter *cube-indices*
  #(;; Front
    0 1 2  2 3 0
    ;; Back
    4 6 5  6 4 7
    ;; Top
    8 9 10  10 11 8
    ;; Bottom
    12 14 13  14 12 15
    ;; Right
    16 17 18  18 19 16
    ;; Left
    20 21 22  22 23 20)
  "Triangle indices for the cube faces")

;;; ============================================================================
;;; Simple Shaders
;;; ============================================================================

(defparameter *vertex-shader-source*
  "#version 330 core
layout (location = 0) in vec3 position;
layout (location = 1) in vec3 color;

out vec3 fragColor;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    gl_Position = projection * view * model * vec4(position, 1.0);
    fragColor = color;
}")

(defparameter *fragment-shader-source*
  "#version 330 core
in vec3 fragColor;
out vec4 FragColor;

void main()
{
    FragColor = vec4(fragColor, 1.0);
}")

;;; ============================================================================
;;; Matrix Math (simple implementations)
;;; ============================================================================

(defun make-identity-matrix ()
  "Create a 4x4 identity matrix"
  (make-array 16 :element-type 'single-float
              :initial-contents '(1.0 0.0 0.0 0.0
                                  0.0 1.0 0.0 0.0
                                  0.0 0.0 1.0 0.0
                                  0.0 0.0 0.0 1.0)))

(defun make-perspective-matrix (fov aspect near far)
  "Create a perspective projection matrix"
  (let* ((f (/ 1.0 (tan (/ fov 2.0))))
         (nf (/ 1.0 (- near far)))
         (mat (make-array 16 :element-type 'single-float :initial-element 0.0)))
    (setf (aref mat 0) (/ f aspect))
    (setf (aref mat 5) f)
    (setf (aref mat 10) (* (+ far near) nf))
    (setf (aref mat 11) -1.0)
    (setf (aref mat 14) (* 2.0 far near nf))
    mat))

(defun make-translation-matrix (x y z)
  "Create a translation matrix"
  (let ((mat (make-identity-matrix)))
    (setf (aref mat 12) x)
    (setf (aref mat 13) y)
    (setf (aref mat 14) z)
    mat))

(defun make-rotation-matrix-y (angle)
  "Create a rotation matrix around Y axis"
  (let ((mat (make-identity-matrix))
        (c (cos angle))
        (s (sin angle)))
    (setf (aref mat 0) c)
    (setf (aref mat 2) s)
    (setf (aref mat 8) (- s))
    (setf (aref mat 10) c)
    mat))

(defun make-rotation-matrix-x (angle)
  "Create a rotation matrix around X axis"
  (let ((mat (make-identity-matrix))
        (c (cos angle))
        (s (sin angle)))
    (setf (aref mat 5) c)
    (setf (aref mat 6) (- s))
    (setf (aref mat 9) s)
    (setf (aref mat 10) c)
    mat))

(defun matrix-multiply (a b)
  "Multiply two 4x4 matrices"
  (let ((result (make-array 16 :element-type 'single-float :initial-element 0.0)))
    (loop for row from 0 below 4 do
      (loop for col from 0 below 4 do
        (let ((sum 0.0))
          (loop for k from 0 below 4 do
            (incf sum (* (aref a (+ (* row 4) k))
                        (aref b (+ (* k 4) col)))))
          (setf (aref result (+ (* row 4) col)) sum))))
    result))

;;; ============================================================================
;;; OpenGL Helper Functions
;;; ============================================================================

(defun compile-shader (source type)
  "Compile a shader from source code"
  (let ((shader (gl:create-shader type)))
    (gl:shader-source shader source)
    (gl:compile-shader shader)

    ;; Check compilation status
    (unless (gl:get-shader shader :compile-status)
      (error "Shader compilation failed: ~A" (gl:get-shader-info-log shader)))

    shader))

(defun create-shader-program (vertex-source fragment-source)
  "Create and link a shader program"
  (let ((vertex-shader (compile-shader vertex-source :vertex-shader))
        (fragment-shader (compile-shader fragment-source :fragment-shader))
        (program (gl:create-program)))

    (gl:attach-shader program vertex-shader)
    (gl:attach-shader program fragment-shader)
    (gl:link-program program)

    ;; Check linking status
    (unless (gl:get-program program :link-status)
      (error "Program linking failed: ~A" (gl:get-program-info-log program)))

    ;; Clean up shaders (they're linked into the program now)
    (gl:delete-shader vertex-shader)
    (gl:delete-shader fragment-shader)

    program))

;;; ============================================================================
;;; Main Application
;;; ============================================================================

(defun run ()
  "Run the rotating cube demo"
  (format t "~%Starting 3D Cube Demo~%")
  (format t "=====================~%")
  (format t "Controls: ESC to quit~%~%")

  ;; Initialize SDL2
  (sdl2:with-init (:video)
    (format t "SDL2 initialized~%")

    ;; Set OpenGL attributes
    (sdl2:gl-set-attr :context-major-version 3)
    (sdl2:gl-set-attr :context-minor-version 3)
    (sdl2:gl-set-attr :context-profile-mask sdl2-ffi:+sdl-gl-context-profile-core+)
    (sdl2:gl-set-attr :doublebuffer 1)

    ;; Create window and OpenGL context
    (sdl2:with-window (window :title "Common Lisp - Rotating 3D Cube"
                              :w 800 :h 600
                              :flags '(:opengl :shown))
      (sdl2:with-gl-context (gl-context window)
        (format t "OpenGL Version: ~A~%" (gl:get-string :version))
        (format t "GLSL Version: ~A~%" (gl:get-string :shading-language-version))
        (format t "Renderer: ~A~%~%" (gl:get-string :renderer))

        ;; Enable depth testing
        (gl:enable :depth-test)
        (gl:depth-func :less)

        ;; Create shader program
        (let ((shader-program (create-shader-program *vertex-shader-source*
                                                     *fragment-shader-source*)))

          ;; Create and bind VAO
          (let ((vao (gl:gen-vertex-array))
                (vbo (gl:gen-buffer))
                (ebo (gl:gen-buffer)))

            (gl:bind-vertex-array vao)

            ;; Upload vertex data
            (gl:bind-buffer :array-buffer vbo)
            (let ((arr (gl:alloc-gl-array :float (length *cube-vertices*))))
              (dotimes (i (length *cube-vertices*))
                (setf (gl:glaref arr i) (coerce (aref *cube-vertices* i) 'single-float)))
              (gl:buffer-data :array-buffer :static-draw arr)
              (gl:free-gl-array arr))

            ;; Upload index data
            (gl:bind-buffer :element-array-buffer ebo)
            (let ((arr (gl:alloc-gl-array :unsigned-short (length *cube-indices*))))
              (dotimes (i (length *cube-indices*))
                (setf (gl:glaref arr i) (aref *cube-indices* i)))
              (gl:buffer-data :element-array-buffer :static-draw arr)
              (gl:free-gl-array arr))

            ;; Set up vertex attributes
            ;; Position attribute
            (gl:vertex-attrib-pointer 0 3 :float nil (* 6 4) 0)
            (gl:enable-vertex-attrib-array 0)

            ;; Color attribute
            (gl:vertex-attrib-pointer 1 3 :float nil (* 6 4) (* 3 4))
            (gl:enable-vertex-attrib-array 1)

            ;; Create projection matrix
            (let ((projection (make-perspective-matrix
                              (/ (* 45.0 pi) 180.0)  ; 45 degree FOV
                              (/ 800.0 600.0)        ; aspect ratio
                              0.1                     ; near plane
                              100.0))                 ; far plane
                  (view (make-translation-matrix 0.0 0.0 -3.0))
                  (angle 0.0)
                  (running t))

              ;; Main loop
              (sdl2:with-event-loop (:method :poll)
                (:quit () (setf running nil))

                (:keydown (:keysym keysym)
                          (when (sdl2:scancode= (sdl2:scancode-value keysym) :scancode-escape)
                            (sdl2:push-event :quit)))

                (:idle ()
                       (unless running
                         (return-from run))

                       ;; Update rotation
                       (incf angle 0.01)

                       ;; Clear screen
                       (gl:clear-color 0.1 0.1 0.1 1.0)
                       (gl:clear :color-buffer :depth-buffer)

                       ;; Use shader program
                       (gl:use-program shader-program)

                       ;; Create model matrix (rotate around X and Y)
                       (let* ((rot-y (make-rotation-matrix-y angle))
                              (rot-x (make-rotation-matrix-x (* angle 0.7)))
                              (model (matrix-multiply rot-y rot-x)))

                         ;; Set uniforms
                         (gl:uniform-matrix-4fv
                          (gl:get-uniform-location shader-program "model")
                          model nil)
                         (gl:uniform-matrix-4fv
                          (gl:get-uniform-location shader-program "view")
                          view nil)
                         (gl:uniform-matrix-4fv
                          (gl:get-uniform-location shader-program "projection")
                          projection nil))

                       ;; Draw cube
                       (gl:bind-vertex-array vao)
                       (gl:draw-elements :triangles (gl:make-null-gl-array :unsigned-short)
                                       :count 36)

                       ;; Swap buffers
                       (sdl2:gl-swap-window window)

                       ;; Small delay to limit frame rate
                       (sdl2:delay 16)))  ; ~60 FPS

              ;; Cleanup
              (gl:delete-vertex-arrays (list vao))
              (gl:delete-buffers (list vbo ebo))
              (gl:delete-program shader-program))))))

  (format t "~%Demo finished!~%"))

;;; Entry point
(format t "~%~%")
(format t "To run this demo:~%")
(format t "1. Install system dependencies (SDL2, OpenGL)~%")
(format t "2. Load required libraries: (ql:quickload '(:cl-opengl :cl-sdl2))~%")
(format t "3. Run: (rotating-cube:run)~%")
(format t "~%")
