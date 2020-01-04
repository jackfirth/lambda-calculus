#lang lambda-calculus

let true = λxy.x
let false = λxy.y
let and = λpq.(p q p)
let or = λpq.(p p q)
let not = λp.(p false true)
let if = λpab.(p a b)

(and true false)

(not true)

((if true and or) true false)

(not (not true))
