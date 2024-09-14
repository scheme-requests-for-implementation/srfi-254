#!r6rs

;; SPDX-FileCopyrightText: 2024 Marc Nieper-Wißkirchen
;; SPDX-License-Identifier: MIT

(library (srfi :254 ephemerons-and-guardians guardians)
  (export
    reference-barrier
    make-guardian
    guardian?)
  (import (srfi :254)))
