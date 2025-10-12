-- lab-wk3
-- Jeremy.Singer@glasgow.ac.uk
-- v1, Thu 5 Oct 23

import Data.Char
import Test.QuickCheck

{--
 1. Write a function `twice` that calls a function f
 supplied as an argument two times on input x.
 Why must f have type (a->a) ?
--}

twice :: (a -> a) -> a -> a
twice f x = f $ f x

{--
 2. Write a function `ntimes` that calls a function f
 supplied as an argument n times on input x (with n and
 x supplied as arguments too)
--}

ntimes :: (a -> a) -> Int -> a -> a
ntimes f n x = if n <= 0 then x else f $ ntimes f (n - 1) x

prop_addm :: Int -> Bool
prop_addm = \m -> if m < 0 then True else ntimes (+ 1) m 0 == m
-- ^ ^^^^ can you quickCheck this property?

{-- 3. write a function `exceptLast` which
  returns all the elements of a list except the
  final one, a little like the dual of the tail
  function.
  Use a recursive function definition.
  How many base cases do you need?
  What should you do with an empty list?
--}

exceptLast :: [a] -> [a]
exceptLast [x] = []
exceptLast (x : xs) = x : exceptLast xs

prop_exceptLast :: (Eq a) => [a] -> Bool
prop_exceptLast = \xs ->
  if length xs > 0
    then (exceptLast xs == reverse (tail (reverse xs)))
    else True
-- ^ ^^^^ can you quickCheck this property?

{--
  3. The Data.Char module has lots of useful helper function
  for characters. One of these is `toUpper`, which transforms a
  lower-case letter into its upper-case equivalent
  Write a function which transforms a list of strings (of mixed case)
  into a list of strings where all the letters are upper case.

  for instance, mkUpperCase [ "Once", "upon", "a", "time"]
  should evaluate to:
  [ "ONCE", "UPON", "A", "TIME"]
--}

mkUpperCase :: [String] -> [String]
mkUpperCase [] = []
mkUpperCase (x : xs) = [Data.Char.toUpper y | y <- x] : mkUpperCase xs

-- Now write a quickCheck test for mkUpperCase
prop_mkUpperCase :: [String] -> Bool
prop_mkUpperCase xs = all (all (\x -> not (isLetter x && isAscii x) || isAsciiUpper x)) (mkUpperCase xs)

{--
 4. Similarly, can you write a function that takes a single
    String and transforms it so the first character is
    upper case and all subsequent characters are lower case

    for instance `tidy "jEREMY"`
    should evaluate to "Jeremy"
--}

tidy :: String -> String
tidy (x : xs) = Data.Char.toUpper x : map Data.Char.toLower xs

{--
  5. Tricky: Given a multi-word string,
  can you make the first letter of each word uppercase, with all
  other letters lowercase?
  So for example, given string "snow white and the seven dwarfs"
  your output should be "Snow White And The Seven Dwarfs"

  You may find the utility functions `words` and `unwords` helpful -
  like String split and join in Python :-)

--}

mkFirstLettersUpper :: String -> String
mkFirstLettersUpper s = unwords $ map tidy $ words s

answer = mkFirstLettersUpper "snow white and the seven dwarfs"

{-- 6. Same as above, only words that are three characters or shorter
    should be all lowercase, i.e.
    mkFirstLettersUpper' "snow white and the seven dwarfs"
    evaluates to:
    "Snow White and the Seven Dwarfs"
--}

mkFirstLettersUpper' :: String -> String
mkFirstLettersUpper' = undefined

answer' = mkFirstLettersUpper' "snow white and the seven dwarfs"

{--
  7. Final part. Do you remember the binary trees datatype
  we looked at on Monday? Can you write some code to generate
  a String representing a depth first, pre-order traversal?

  So for tree1 below, the nodes should appear in order in the
  output String i.e. 1 2 3 4 5
--}

data Tree = Leaf | Node Int Tree Tree

tree1 = Node 1 (Node 2 Leaf Leaf) (Node 3 (Node 4 Leaf Leaf) (Node 5 Leaf Leaf))

dfs_preorder :: Tree -> String
dfs_preorder Leaf = ""
dfs_preorder (Node val t1 t2) = (show val ++ " ") ++ dfs_preorder t1 ++ dfs_preorder t2

{--
 8. OK one more tiny bit for a bonus ... how about an inorder traversal, which
    would give "2 1 4 3 5" - I think ...
--}

dfs_inorder :: Tree -> String
dfs_inorder Leaf = ""
dfs_inorder (Node val t1 t2) = dfs_inorder t1 ++ (show val ++ " ") ++ dfs_inorder t2
