;;;; Disassembly Comparison - Proving Unboxing in SBCL

(defpackage :disassemble-comparison
  (:use :cl))

(in-package :disassemble-comparison)

;;; Simple iterative functions for clear comparison

(defun add-naive (n)
  "Addition without type declarations."
  (let ((sum 0))
    (loop repeat n
          do (setf sum (+ sum 1)))
    sum))

(defun add-optimized (n)
  "Addition with type declarations."
  (declare (optimize (speed 3) (safety 0) (debug 0))
           (type fixnum n))
  (let ((sum 0))
    (declare (type fixnum sum))
    (loop repeat n
          do (setf sum (the fixnum (+ sum 1))))
    sum))

(format t "~%~%")
(format t "================================================================================~%")
(format t "NAIVE VERSION (No type declarations)~%")
(format t "================================================================================~%")
(format t "~%Notice: Look for GENERIC-+ (boxed arithmetic) and heap allocations~%~%")
(disassemble 'add-naive)

(format t "~%~%")
(format t "================================================================================~%")
(format t "OPTIMIZED VERSION (With type declarations)~%")
(format t "================================================================================~%")
(format t "~%Notice: Look for direct CPU instructions (ADD, INC) - unboxed arithmetic~%~%")
(disassemble 'add-optimized)

(format t "~%~%")
(format t "================================================================================~%")
(format t "KEY DIFFERENCES TO OBSERVE:~%")
(format t "================================================================================~%")
(format t "~%")
(format t "NAIVE (boxed):~%")
(format t "  - Calls GENERIC-+ or similar runtime functions~%")
(format t "  - May allocate memory for intermediate results~%")
(format t "  - Type checks on every operation~%")
(format t "~%")
(format t "OPTIMIZED (unboxed):~%")
(format t "  - Uses direct CPU instructions (ADDQ, INCQ, etc.)~%")
(format t "  - No function calls for arithmetic~%")
(format t "  - No heap allocations~%")
(format t "  - Numbers stay in CPU registers~%")
(format t "~%")
(format t "In SBCL, fixnums are tagged with low bits. When unboxed, SBCL uses~%")
(format t "direct register operations. When boxed, it needs runtime dispatch.~%")
(format t "~%~%")
