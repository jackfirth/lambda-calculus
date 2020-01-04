#lang racket/base

(module reader racket/base
  (require racket/contract/base)

  (provide
   (contract-out
    [rename lambda-calculus-read read reader/c]
    [rename lambda-calculus-read-syntax read-syntax syntax-reader/c]))

  (require lambda-calculus/lexing
           lambda-calculus/parsing)

  (define line/c (or/c exact-positive-integer? #f))
  (define column/c (or/c exact-nonnegative-integer? #f))
  (define position/c (or/c exact-positive-integer? #f))
  (define source-name/c (or/c symbol? string? path?))

  (define reader/c
    (case->
     (-> input-port? any/c)
     (-> input-port? module-path? line/c column/c position/c any/c)))

  (define syntax-reader/c
    (case->
     (-> source-name/c input-port? syntax?)
     (-> source-name/c input-port? syntax? line/c column/c position/c syntax?)))
  
  (define lambda-calculus-read
    (case-lambda
      [(in) #f]
      [(in reader-module line column position) #f]))

  (define lambda-calculus-read-syntax
    (case-lambda
      [(source-name in)
       (define parse-tree (parse source-name (make-tokenizer in)))
       (define module-datum
         `(module lambda-calculus-module lambda-calculus/expansion ,parse-tree))
       (datum->syntax #f module-datum)]
      [(source-name in reader-module-stx line column position)
       (lambda-calculus-read-syntax source-name in)])))

(module+ main
  (require (submod ".." reader)))
