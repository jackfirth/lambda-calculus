#lang racket/base

(provide (rename-out [lambda-calculus-module-begin #%module-begin])
         #%top-interaction)

(require (for-syntax racket/base
                     syntax/parse)
         syntax/parse/define)

;@------------------------------------------------------------------------------

(begin-for-syntax
  (define-syntax-class lc-program
    #:attributes ([preprocessed 1])
    (pattern (program (~or :lc-definition :lc-expression) ...+)))

  (define-syntax-class lc-definition
    #:attributes (preprocessed)
    (pattern
        (definition "let"
                    id:id
                    "="
                    right-hand-side:lc-expression)
      #:with preprocessed
      #'(define id right-hand-side.preprocessed)))

  (define-syntax-class lc-expression
    #:attributes (preprocessed)
    (pattern (expression id:id)
      #:with preprocessed #'id)
    (pattern
        (expression
         (lambda-abstraction parameters:lc-parameters body:lc-expression))
      #:with preprocessed
      #'(λ (parameters.id ...) body.preprocessed))
    (pattern (expression
              (function-application "("
                                    expr:lc-expression ...
                                    ")"))
      #:with preprocessed
      #'(expr.preprocessed ...)))

  (define-syntax-class lc-identifier
    #:attributes (id)
    (pattern (identifier id:identifier)))

  (define-syntax-class lc-parameters
    #:attributes ([id 1])
    (pattern (id:id ...))))

(define-simple-macro (lambda-calculus-module-begin program:lc-program)
  (#%module-begin program.preprocessed ...))
