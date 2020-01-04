#lang racket

(provide make-tokenizer)

(require brag/support)

(define (make-tokenizer in)
  (define (next-token)
    (define bf-lexer
      (lexer
       [(from/to "#" "\n") (next-token)]
       [whitespace (next-token)]
       ["let" lexeme]
       [(char-set "()=_") lexeme]
       [(concatenation "λ" (repetition 1 +inf.0 alphabetic) ".")
        (token 'PARAMETERS
               (for/list ([pos (in-range 1 (sub1 (string-length lexeme)))])
                 (string->symbol (substring lexeme pos (add1 pos)))))]
       [(concatenation alphabetic
                       (repetition 0 +inf.0 (union alphabetic numeric)))
        (token 'IDENTIFIER (string->symbol lexeme))]))
    (bf-lexer in))
  next-token)
