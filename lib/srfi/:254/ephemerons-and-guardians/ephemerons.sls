#!r6rs

(library (srfi :254 ephemerons-and-guardians ephemerons)
  (export
    reference-barrier
    make-ephemeron
    ephemeron?
    ephemeron-key
    ephemeron-value
    ephemeron-broken?)
  (import (srfi :254)))
