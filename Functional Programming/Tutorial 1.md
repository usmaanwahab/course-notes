```haskell
max2 :: Int -> Int -> Int
max2 = max

max3 :: Int -> Int -> Int -> Int
max3 a b = max2 (max2 a b)

f :: (Int -> String) -> (String -> Bool) -> (Int -> Bool)
f a b = b . a

intToString :: Int -> String
intToString = show

digitToBool :: String -> Bool
digitToBool a = read a /= 0

g :: (Int -> Bool) -> (Bool -> String) -> Int -> String
g a b = b . a

twice :: (Int -> Int) -> Int -> Int
twice f = f . f

phys :: Double -> Double -> Double -> Double
phys m1 m2 d = let g = 6.67e-11 in (g * m1 * m1) / d ** 2

oneToThirtyDivisibleBy3 = [x | x <- [1 .. 30], x `mod` 3 == 0]

triangleNums n = [((x * (x + 1)) `div` 2) | x <- [1 .. n]]

primes :: Int -> [Int]
primes n = [x | x <- [1 .. n], all (\y -> x `mod` y /= 0) [2 .. x - 1]]

flatten :: [[a]] -> [a]
flatten [] = []
flatten (x : xs) = x ++ flatten xs

```