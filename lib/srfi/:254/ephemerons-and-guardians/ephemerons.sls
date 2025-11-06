#!r6rs

;; SPDX-FileCopyrightText: 2024 Marc Nieper-Wißkirchen
;; SPDX-License-Identifier: MIT

(library (srfi :254 ephemerons-and-guardians ephemerons)
  (export
    reference-barrier
    make-ephemeron
    ephemeron?
    ephemeron-key
    ephemeron-value
    ephemeron-broken?
    ephemeron-ref)
  (import (srfi :254)))
