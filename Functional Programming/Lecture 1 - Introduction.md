In functional programming languages functions are **first-class**.
**Imperative** languages describe a sequence of steps to compute a result. 
**Functional** languages describe how to reduce an expression to a value.

```haskell
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = 
	quicksort [y | y <- xs, y <= x] ++ 
	[x] ++ 
	quicksort [y | y <- xs, y > x]
```

Haskell is a general-purpose, statically-typed, purely functional programming language with type inference and lazy evaluation.

An **expression** is a term in the language that eventually reduces to a value.

In Haskell everything is an expression. For example, all if-else statements must have both an `if` and `else` clause, so that it remains a valid expression.

```haskell
-- Conditional Statements as Expression
if 2 < 3 then
	"two is less than three"
else
	"three is less than two"
	
-- Statements as Expressions
let msg = 
	if 2 < 3 then
		"two is less than three"
	else
		"three is less than two"
in 
	"Result: " ++ msg
```

Each expression has a **type**, which classify values. Types allow the compiler to rule out nonsensical expressions (e.g. 5+True).

Haskell is **statically typed**: type errors are caught before a program is run. Haskell can also **infer** a type for most expressions, but it is good practice to add in a type signature for top-level functions.

Functional reduction is where we **reduce** complex expressions to a **value**.

The Church-Rosser property states that reductions can be performed in any order, with respect to operational precedence.

In the context of abstract rewiring systems, reduction is confluent. Church-Rosser is useful for equitational reasoning and functional parallelism 