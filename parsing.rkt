#lang brag
program : (definition | expression)*
definition : "let" IDENTIFIER "=" expression
expression : IDENTIFIER | function-application | lambda-abstraction
lambda-abstraction : PARAMETERS expression
function-application : "(" expression+ ")"
