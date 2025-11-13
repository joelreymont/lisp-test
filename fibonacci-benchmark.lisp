;;;; Fibonacci Benchmark - Demonstrating SBCL Optimization
;;;; This file compares performance with and without type/optimization declarations

(defpackage :fibonacci-benchmark
  (:use :cl)
  (:export :run-benchmark))

(in-package :fibonacci-benchmark)

;;; ============================================================================
;;; UNOPTIMIZED VERSIONS (No type declarations, default optimization)
;;; ============================================================================

(defun fib-recursive-naive (n)
  "Naive recursive Fibonacci without any optimization."
  (if (<= n 1)
      n
      (+ (fib-recursive-naive (- n 1))
         (fib-recursive-naive (- n 2)))))

(defun fib-iterative-naive (n)
  "Iterative Fibonacci without type declarations."
  (if (<= n 1)
      n
      (let ((a 0)
            (b 1))
        (loop repeat (- n 1)
              do (let ((temp (+ a b)))
                   (setf a b
                         b temp)))
        b)))

;;; ============================================================================
;;; OPTIMIZED VERSIONS (With type declarations and optimization)
;;; ============================================================================

(defun fib-recursive-optimized (n)
  "Recursive Fibonacci with type declarations and optimization."
  (declare (optimize (speed 3) (safety 0) (debug 0))
           (type fixnum n))
  (if (<= n 1)
      n
      (the fixnum (+ (the fixnum (fib-recursive-optimized (the fixnum (- n 1))))
                     (the fixnum (fib-recursive-optimized (the fixnum (- n 2))))))))

(defun fib-iterative-optimized (n)
  "Iterative Fibonacci with full type declarations and optimization."
  (declare (optimize (speed 3) (safety 0) (debug 0))
           (type fixnum n))
  (if (<= n 1)
      n
      (let ((a 0)
            (b 1))
        (declare (type fixnum a b))
        (loop repeat (- n 1)
              do (let ((temp (the fixnum (+ a b))))
                   (declare (type fixnum temp))
                   (setf a b
                         b temp)))
        b)))

;;; ============================================================================
;;; BENCHMARKING UTILITIES
;;; ============================================================================

(defun benchmark-function (fn arg iterations)
  "Benchmark a function by running it multiple times and measuring elapsed time."
  (let ((start-time (get-internal-real-time)))
    (dotimes (i iterations)
      (funcall fn arg))
    (let* ((end-time (get-internal-real-time))
           (elapsed (/ (- end-time start-time) internal-time-units-per-second)))
      elapsed)))

(defun format-time (seconds)
  "Format time in appropriate units."
  (cond
    ((< seconds 0.001) (format nil "~,3f μs" (* seconds 1000000)))
    ((< seconds 1.0) (format nil "~,3f ms" (* seconds 1000)))
    (t (format nil "~,3f s" seconds))))

(defun print-separator ()
  (format t "~%~80a~%" (make-string 80 :initial-element #\=)))

(defun run-comparison (fn-name-1 fn-1 fn-name-2 fn-2 n iterations)
  "Compare two functions and show the speedup."
  (format t "~%Testing with n=~a (~a iterations)~%" n iterations)
  (format t "~40a: " fn-name-1)
  (force-output)
  (let ((time-1 (benchmark-function fn-1 n iterations)))
    (format t "~a~%" (format-time time-1))
    (format t "~40a: " fn-name-2)
    (force-output)
    (let ((time-2 (benchmark-function fn-2 n iterations)))
      (format t "~a~%" (format-time time-2))
      (format t "~40a: ~,2fx faster~%"
              "Speedup"
              (/ time-1 time-2)))))

;;; ============================================================================
;;; MAIN BENCHMARK
;;; ============================================================================

(defun run-benchmark ()
  "Run comprehensive Fibonacci benchmarks."
  (format t "~%")
  (print-separator)
  (format t "FIBONACCI BENCHMARK - SBCL Optimization Comparison")
  (print-separator)
  (format t "~%Lisp Implementation: ~a ~a"
          (lisp-implementation-type)
          (lisp-implementation-version))
  (print-separator)

  ;; Recursive Fibonacci Comparison
  (format t "~%~%RECURSIVE FIBONACCI")
  (print-separator)
  (run-comparison "Naive (no optimization)" #'fib-recursive-naive
                  "Optimized (speed 3, types)" #'fib-recursive-optimized
                  20 10000)

  (run-comparison "Naive (no optimization)" #'fib-recursive-naive
                  "Optimized (speed 3, types)" #'fib-recursive-optimized
                  25 1000)

  ;; Iterative Fibonacci Comparison
  (format t "~%~%ITERATIVE FIBONACCI")
  (print-separator)
  (run-comparison "Naive (no optimization)" #'fib-iterative-naive
                  "Optimized (speed 3, types)" #'fib-iterative-optimized
                  1000 100000)

  (run-comparison "Naive (no optimization)" #'fib-iterative-naive
                  "Optimized (speed 3, types)" #'fib-iterative-optimized
                  10000 10000)

  ;; Verify correctness
  (format t "~%~%CORRECTNESS CHECK")
  (print-separator)
  (let ((test-n 20))
    (format t "~%fib(~a) results:~%" test-n)
    (format t "  Recursive naive:     ~a~%" (fib-recursive-naive test-n))
    (format t "  Recursive optimized: ~a~%" (fib-recursive-optimized test-n))
    (format t "  Iterative naive:     ~a~%" (fib-iterative-naive test-n))
    (format t "  Iterative optimized: ~a~%" (fib-iterative-optimized test-n)))

  (print-separator)
  (format t "~%Benchmark complete!~%~%"))

;;; Run the benchmark when this file is loaded
(run-benchmark)
