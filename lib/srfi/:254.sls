#!chezscheme

;; SPDX-FileCopyrightText: 2024 Marc Nieper-Wißkirchen
;; SPDX-License-Identifier: MIT

(library (srfi :254)
  (export
    reference-barrier
    make-ephemeron
    ephemeron?
    ephemeron-key
    ephemeron-value
    ephemeron-broken?
    make-guardian
    guardian?
    current-hash
    make-transport-cell-guardian
    transport-cell-guardian?
    transport-cell?
    transport-cell-key
    transport-cell-value
    transport-cell-broken?)
  (import

    (rename (chezscheme)
            (make-guardian $make-guardian)
            (guardian? $guardian?)))

  (import (only $system $fxaddress $immediate?))

  ;; Reference barrier

  (define reference-barrier
    (lambda (obj)
      (keep-live obj)))

  ;; Ephemerons

  (define make-ephemeron
    (lambda (key value)
      (assert (not (immediate? key)))
      (ephemeron-cons key value)))

  (define ephemeron?
    (lambda (obj)
      (ephemeron-pair? obj)))

  (define ephemeron-broken?
    (lambda (obj)
      (assert (ephemeron-pair? obj))
      (bwp-object? (car obj))))

  (define ephemeron-key
    (lambda (eph)
      (assert (ephemeron-pair? eph))
      (let ([key (car eph)])
        (and (not (bwp-object? key)) key))))

  (define ephemeron-value
    (lambda (eph)
      (assert (ephemeron-pair? eph))
      (let ([value (cdr eph)])
        (and (not (bwp-object? (car eph))) value))))

  ;; Guardians

  (define $guardian (string-copy "guardian"))

  (define make-guardian
    (lambda ()
      (let ([g ($make-guardian)])
        (make-wrapper-procedure
         (case-lambda
           [()
            (g)]
           [(obj)
            (assert (not (immediate? obj)))
            (g obj)]
           [(obj rep)
            (assert (not (immediate? obj)))
            (g obj rep)])
         7 $guardian))))

  (define (guardian? g)
    (and (wrapper-procedure? g)
         (eq? (wrapper-procedure-data g) $guardian)))

  ;; Transport guardians

  (define current-hash
    (let ([w (fixnum-width)])
      (lambda (obj)
        (fxrotate-bit-field ($fxaddress obj)
			    0 (fx- w 1) (fx- w 4)))))

  (define $transport-cell-guardian (string-copy "transport-cell-guardian"))

  (define make-transport-cell-guardian
    (lambda ()
      (let ([g ($make-guardian)])
        (make-wrapper-procedure
         (case-lambda
           [(key value)
            (let ([tc (weak-cons key value)])
              (unless (immediate? key)
                (g (weak-cons tc #f))
                tc))]
           [()
            (let f ([m (g)])
	      (and m
		   (cond
		    [(bwp-object? (car m))
		     (f (g))]
		    [else
		     (g m)
		     (car m)])))])
         5 $transport-cell-guardian))))

  (define (transport-cell-guardian? g)
    (and (wrapper-procedure? g)
         (eq? (wrapper-procedure-data g) $transport-cell-guardian)))

  (define transport-cell?
    (lambda (obj)
      (weak-pair? obj)))

  (define transport-cell-key
    (lambda (tc)
      (assert (weak-pair? tc))
      (let ([key (car tc)])
        (and (not (bwp-object? key)) key))))

  (define transport-cell-value
    (lambda (tc)
      (assert (weak-pair? tc))
      (cdr tc)))

  (define transport-cell-broken?
    (lambda (tc)
      (assert (weak-pair? tc))
      (bwp-object? (car tc))))

  ;; Implementation

  (define immediate?
    (lambda (x)
      (or (fixnum? x) ($immediate? x)))))
