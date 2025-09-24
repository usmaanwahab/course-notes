A **tuple** is an ordered sequence of expressions, with a known length.
We can deconstruct a **pair** by using the `fst` and `snd` functions.

```haskell
fst (1, "hello") -- outputs 1
snd (1, "hello") -- outputs "hello"
```

We can also deconstruct by **pattern matching**.
```haskell
let (x, y) = (1, "hello") in x -- outputs 1
```

A common pattern is 
```haskell
-- EMPTY LIST CAUSES RUNTIME EXCEPTION
let (x:xs) = [1,3,3,4,5] in x -- outputs 1
let (x:xs) = [1,3,3,4,5] in xs -- outputs [3,3,4,5]
```

A **function** maps a value to another value.
Function definitions have parameters, which act as placeholders for arguments when the function is applied. In Haskell, a function is **first-class**. This means we can `let-bind` it, return it from another function, pass it as an argument, etc.

```haskell
\name -> "Hello, " ++ name
\n -> n + 5
```

Functions without a name (like the above) are known as anonymous.

A function maps a single argument to a result. To allow for multiple arguments we could use a tuple as follows.
```haskell
\(n1, n2) -> n1 + n2
```
However, it is not ideal to construct and deconstruct a tuple to interface with the function.

Instead we can use **currying**. This is the idea of nesting multiple functions.
```haskell
\n1 -> (\n2 -> n1 + n2) -- Int -> (Int -> Int)
```

You can see from the definition and type signature that passing an integer returns a function that takes an integer. So we basically return a function with a fixed `n1` and to complete the evaluation we need to provide `n2`.

```haskell
-- Write an anonymous function that calcualtes the cube of a number
\n -> n*n*n -- Num a -> a -> a
\n -> n**3 -- Floating a => a -> a
\n -> n^2 -- Num a => a -> a
```

An **equation** gives meaning to a name.
```haskell
favouriteNumber = 5
add = \x -> \y -> x + y
```

Equations can be used to define functions more concisely.
```haskell
add x y = x + y
min x y = if x < y then x else y
```

A **function** takes some arguments, performs some computation, and returns a **result**.
Haskell has many useful functions defined in the Prelude

An advantage of currying is **partial application**
```haskell
add x y = x + y
addFive = add 5
addFive 3 -- outputs 8 
```

This allows us to specialise a function without needing to rewrite or duplicate logic.

We can **compose** two functions using the function composition operator.
```haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
f (.) g = \x -> f(g(x))
```

Function composition is used to write code in **point-free** style, which tries to avoid introducing variable names where possible.

```haskell
show . add10

\x -> show (add10 x)
```

It is important to note that equations are **not** assignments. In an imperative language we write something like 
```c
int x = 0;
x++;
```
This modifies the value referred to by a variable x.

If we try to execute the following in Haskell, it will fail.
```haskell
x = 5
x = x + 1 -- This fails.
```

Reassignment is **not permitted**. It doesn't make sense for x to be defined as both 5 and 6.
You never destroy old values, just compute new ones.

Haskell also supports **parametric polymorphism**, that is, a function can support multiple type by having explicit definitions for each supported scenario.
```haskell
-- Not valid Haskell
\x -> \y -> x :: Int -> Bool -> Int
\x -> \y -> x :: String -> Int -> String
\x -> \y -> x :: Float -> Bool -> Float
```

Polymorphic functions have **type variables** to stand for types.
```haskell
-- Not valid Haskell
\x -> \y -> x :: a -> b -> a
\x -> x :: a -> a
```

It is possible to also have type variables in types (e.g, tuples and lists).
```haskell
-- Not valid Haskell
reverse :: [a] -> [a]
\(x, y) -> (y, x) :: (a, b) -> (b, a)
```

A **list** is an **ordered** sequence of values of the same type.
Haskell supports a concise notation for creating ordered lists.
```haskell
[1..10]
['a'..'z']
[1..]
```

Not these are constructed **lazily**, you can construct an infinite list and Haskell will only compute what you use.

Haskell also supports list comprehension using set builder notation.
```haskell
-- <identifier> = [<body>, <generators>, <condition>]
doubleEvens = [2*x | x <- [1..], x `mod` 2 == 0]
```

There are several methods to access elements in a list.
```haskell
head :: [a] -> a
tail :: [a] -> [a]
(!!) :: [a] -> Int -> a
```

However, it is only recommended to use these if you know what you are doing as they can lead to undefined behaviour, it it often safer to use pattern matching.

The `zip` function allows us to join to lists element-wise.
```haskell
zip :: [a] -> [b] -> [(a, b)]
```

We can also zip with a custom function like so
```haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith (*) [1,2,3,4] [4,3,2,1] -- outputs [4,6,6,4]
```

Use a tuple when you know the number of values you are storing, or the types of values you are storing are different.

Use a list when you don't necessarily know the number of element in advance, you have an ordered sequence of values of the same type, or you want to operate uniformly over your data.

An example of a program which calculates roots using the quadratic formula

```haskell
roots a b c =
	let 
		-- within this let clause we can use previously bound patterns
		det2 = b * b - 4 * a * c
		det = sqrt det2
		rootp = (-b + det) / a / 2
		rootm = (-b - det) / a / 2
	in
		-- the body has access to all variables bound in the let clause
		[rootm, rootp]
		

-- or equivalently 
roots a b c = 
	let det2 = b * b - 4 * a * c in 
		let det = sqrt det2 in
			let rootp = (-b + det) / a / 2
				let rootm = (-b - det) / a / 2 
	in 
		[rootm, rootp]
```

Note each **let** needs a **continuation** (the rest of the computation). This is because it is not a statement.

Haskell supports `where` bindings which are equivalent to `let` bindings but bindings go after the function body.

```haskell
roots a b c = [rootm, rootp]
	where
		det2 = b * b – 4 * a * c
		det = sqrt det2
		rootp = (-b + det)/ a / 2
		rootm = (-b - det)/ a / 2
```

In languages like C/Java we have **switch/case** statements.
```C
switch (num) {
	case 1: return “one”
	case 2: return “two”
	case 3: return “three”
	default:
		return “something else”
}
```

In Haskell we have **guards**.
```haskell
gradeFromGPA :: Int -> String
gradeFromGPA gpa
	| gpa >= 18 = "A"
	| gpa >= 15 = "B"
	| gpa >= 12 = "C"
	| otherwise "below C"
```