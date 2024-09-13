#!r6rs

(library (srfi :254 ephemerons-and-guardians)
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
  (import (srfi :254)))
