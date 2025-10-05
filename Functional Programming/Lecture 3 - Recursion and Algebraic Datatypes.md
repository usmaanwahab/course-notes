```haskell
case num of 
	1 -> "one"
	2 -> "two"
	3 -> "three"
	_ -> "something else"

case list of 
	[] -> "empty"
	[x] -> "one element"
	_ -> "more elements"
```

The idea is to allow **pattern matching** within a definition.

Lists in Haskell are an **inductively-defined** data structure.
```haskell
[] :: [a]
(:) :: a -> [a] -> [a]
```
This allows use to write recursive functions over lists.

```Haskell
listSum :: [Int] -> Int
listSum [] = 0
listSum (x:xs) = x + (listSum xs)
```

In functional languages, recursion is our basic building block. This is because we often want to use the data to construct a new result expression.

As seen above we first write the base case, you will want (at least pure) functions to terminate. Then write a recursive case that calls the same function with an argument which converges to the base case

```haskell
fac :: Int -> Int
fac 0 = 1
fac n = 
	if n < 0 then
		error "bad argument"
	else
		n * (fac $ n-1)
		
```

```haskell
fib :: Int -> Int
fib 0 = 0
fib n
	| n < 3 = 1
	| otherwise = (fib $ n - 1) + (fib $ n - 2)
```

```haskell
fib :: Int -> Int
fib 0 = 0 
fib n = 
	if n < 2 then 1
	else fib' 0 1 2
		where 
			fib' prev1 prev2 idx = 
			if idx == n then prev1 + prev2
			else fib prev2 (prev1+prev2) (idx+1)
```

Haskell uses **tail call optimisation**. All tail calls can be implemented in constant stack space.
Sometimes we want to write mutually recursive functions, which call on each other. Haskell allows us to do that, since all other definitions are in scope.

```haskell
tick :: Int -> String
tick 0 = ""
tick n = "tick " ++ tock $ n-1

tock :: Int -> String
tock 0 = ""
tock n = "tock" ++ tick $ n-1 
```

#### Algebraic Data Types

We can use the `data` keyword to define a new type.
```haskell
data Season = Spring | Summer | Autumn | Winter
```
`Season` is a sum type, with alternative values (see enumerate types in C).
All of Spring, Summer, Autumn, Winter have type `Season`.
```haskell
data UofGGrade = Grade Char Int
```
This is a product type, with a combination of values.

Richer Data Types with Content
```haskell
data Suit = Hearts | Diamonds | Clubs | Spades
data Card = King Suit | Queen Suit | Jack Suit | Ace Suit | Number Suit Int
```
Each data constructor can also have some associated data.

```haskell
showCard :: Card -> String
showCard (King _) -> "K"
showCard (Queen _) -> "Q"
showCard (Number _ n) -> (show n)
```
When working with a data type, we often need to **pattern match** to see which data constructor was used to construct the value. Notice we need brackets around compound values.

Pattern matching can be done using **equations** (as here) or **case** expressions

A recursive data type is a **binary tree**.
```haskell
data Tree = Leaf | Node Int Tree Tree
```
This defines a binary tree with an Int payload value at each non-leaf node.

Parameterised data types
```haskell
data BinaryTree a = Leaf | Node a (BinaryTree a) (BinaryTree a)
```
We can parameterise a data type by putting a type variable on the left hand side of the definition.

We have already seen an example of this: the list type `[a]` can contain any type of values.

```haskell
data Tree = Leaf | Node Int Tree Tree

treeSum :: Tree -> Int
treeSum Leaf = 0
treeSum (Node x left right) = x + treeSum left +  treeSum right 
```

Inverting a binary tree
```haskell
invert :: BinaryTree a -> BinaryTree a
invert Leaf = Leaf
invert (Node x t1 t2) = Node x (invert t2) (invert t1)
```

The **Maybe** type is useful for potentially failing computations. The Maybe type says that either this is some data (Just a), or there is Nothing