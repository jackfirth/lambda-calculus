#lang info

(define collection "lambda-calculus")

(define scribblings
  (list (list "main.scrbl"
              (list 'multi-page)
              (list 'library)
              "lambda-calculus")))

(define deps
  (list "base"))

(define build-deps
  (list "racket-doc"
        "rackunit-lib"
        "scribble-lib"))
