\documentclass[landscape]{beamer}
%#A90D91
%\documentclass[landscape]{slides}
%\usepackage[landscape]{geometry}
\usepackage{color}
\usepackage{mdwlist}
\usepackage{float}
\usepackage{amsfonts}
\usepackage{bm}
\usepackage{enumitem}
% \usepackage[T1]{fontenc}

% Configuring to use Haskell Code
\input{listings_config}
\input{beamer_config}

\ignore{
\begin{code}
module Presentation where
import Data.List (delete)
import Prelude hiding ((.), Maybe(..), zipWith, iterate, map, concat, foldr, head, tail, sum, length)
\end{code}}

\title{Why Haskell Matters}
\author{Roman Gonzalez}
\institute{Vancouver Haskell Meetup}

\begin{document}
  
\begin{frame}
\titlepage
\end{frame}

\begin{frame}
  \frametitle{So what is this language about?}
  \begin{quotation}
    Haskell is a \emph{pure}, \emph{statically typed}, \emph{lazy} \emph{functional} programming language.
  \end{quotation}
  \vfill
  \begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=2em]
    \item Name inspired by mathematician Haskell Brooks Curry
    \item Based on a more primitive language called \textit{Lambda Calculus}
    \item There is no iteration or sequences of actions, everything is recursive
  \end{itemize}
\end{frame}

\begin{frame}
\frametitle{When learning Haskell is a good idea?}
\begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=2em]
  \item If you are a experienced developer that wants to grow professionally
        by learning completely new and different approaches to solve problems
  \item If you need to build systems where correctness is \textbf{critical} (Banks, Safety-Critical Systems)
  \item Is well suited to implement Domain Specific Languages, so it could work very well 
        in systems programming
  \item as Erlang, it is easy to implement parallel and concurrent programs safely due to 
        the pureness of the language
\end{itemize}
\end{frame}

\begin{frame}
\frametitle{Benefits of using Haskell}
\begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=2em]
  \item Algorithms are normally shorter and more concise than their
        iterative versions
  \item Due to the use of function composability, \textit{curryfication} and
        high-order functions, code can be reused in really smart ways
  \item The kick-ass type system with type inference makes you develop code that would normally work
        at the first compilation
\end{itemize}
\end{frame}

\begin{frame}
\frametitle{Properties of Haskell}
\begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=2em]
  \item Functions won't perform sequentially, instead they will 
        evaluate expressions when needed (lazily)
  \item There is a controlled environment for side effect functions 
        but by default functions are \textbf{pure} (non-side effect).
  \item Management of resources is abstracted completely from the developer 
        (GC and automatic allocation of data included)
  \item Strong typing makes correctness happen, and most of the the issues regarding this type systems 
        won't get on the way due to the compiler's type inference system
\end{itemize}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Quicksort in C}
\begin{clang}
void qsort(int a[], int lo, int hi) {
  int h, l, p, t;
  if (lo < hi) {
    l = lo;
    h = hi;
    p = a[hi];

    do {
      while ((l < h) && (a[l] <= p)) 
          l = l+1;
      while ((h > l) && (a[h] >= p))
          h = h-1;
      if (l < h) {
          t = a[l];
          a[l] = a[h];
          a[h] = t;
      }
    } while (l < h);

    a[hi] = a[l];
    a[l] = p;

    qsort( a, lo, l-1 );
    qsort( a, l+1, hi );
  }
}
\end{clang}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Quicksort in Haskell}
\begin{code}
qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) = (qsort lower) ++ [x] ++ (qsort upper)
  where
    lower = filter (< x) xs
    upper = filter (>= x) xs

-- qsort [4,5,1,6,3,2]
-- First execution: 
-- x = 4
-- xs = [5,1,6,3,2]
-- lower = [1,3,2]
-- upper = [5,6]
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Simple Functions}
  \framesubtitle{One parameter functions}

Haskell has \textbf{only} one parameter functions
\begin{code}
inc :: Int -> Int
inc x = x + 1

isNotZero :: Int -> Bool
isNotZero x = x /= 0
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{High Order Functions}
  \framesubtitle{Functions that returns functions}

\begin{code}
add :: Int -> (Int -> Int)
add x = \y -> x + y

compare :: (Eq a) => a -> (a -> Bool)
compare a = \b -> a == b

-- Syntactic Sugar complements of Haskell
add' :: Int -> Int -> Int
add' x y = x + y

compare' :: (Eq a) => a -> a -> Bool
compare' x y = x == y
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{High Order Functions}
  \framesubtitle{Assign returned functions directly}
If \verb+inc+ is a function of type: \\[0.3cm]
\verb+Int -> Int+ \\[0.3cm]
and \verb;(+1); is a function of type: \\[0.3cm]
\verb+Int -> Int+ \\[0.3cm]
Then why don't assign it directly? This is called \textit{curryfication}

\begin{code}
inc' = (1 +)
isNotZero' = (0 /=)
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{High Order Functions}
  \framesubtitle{Functions that receive functions as parameters}
Functions can also receive functions as parameters:
\begin{code} % code not be evaluated by haskell
filter :: (a -> Bool) -> [a] -> [a]
filter fn (x:xs)
  | fn x = x : filter fn xs
  | otherwise = filter fn xs

-- filter isNotZero [1,0,2,0,3]
-- => [1,2,3]
\end{code}
They can also be curryfied:
\begin{code}
removeZeros :: [Int] -> [Int]
removeZeros = filter isNotZero
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Lists}
  \framesubtitle{Definition of a list}
  \begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=1em]
    \item An \textit{empty} value: \verb+[]+
    \item A \textit{cons} value: 
      Item on the left and list on the right, the whole thing being a new list
      \verb+[1,2,3] == (1:2:3:[]) == (1:(2:(3:[])))+
  \end{itemize}
  \vfill
  So we have two basic functions to get the two components of a \textit{cons}:
\begin{code}
head :: [a] -> a
head (x:_) = x

tail :: [a] -> [a]
tail (_:xs) = xs
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Let's define some functions}
  \framesubtitle{Simple functions with a common interface}
\begin{code}
sum :: (Num a) => [a] -> a
sum [] = 0
sum (x:xs) = x + sum xs

prod :: (Num a) => [a] -> a
prod [] = 1
prod (x:xs) = x * prod xs

length :: [a] -> Int
length [] = 0
length (x:xs) = 1 + length xs
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Folding}
  \framesubtitle{Basics}
\begin{code}
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr fn zero [] = zero
foldr fn zero (x:xs) = fn x (foldr fn zero xs)

{-
foldr (+) 0 [3,2,5]

- [] is replaced by 0
- (:) function is replaced by the (+) function

-> 3 : (2 : (5 : []))
-> 3 + (2 + (5 +  0))
-}
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Folding}
  \framesubtitle{Using foldr and partially applied functions}
\begin{code}
-- foldr (+) 0 :: (Num a) => [a] -> a
sum' = foldr (+) 0

-- foldr (*) 1 :: (Num a) => [a] -> a
prod' = foldr (*) 1

-- foldr (+) 0 :: (Num a) => [a] -> a
length' = foldr (\_ accum -> 1 + accum) 0
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Folding}
  \framesubtitle{Insertion Sort}
\begin{code}
insertion :: (Ord a) => a -> [a] -> [a] 
insertion a [] = [a]
insertion a (b:bs) 
  | a <= b = (a:b:bs)
  | otherwise = (b : insertion a bs)

insertionSort :: (Ord a) => [a] -> [a]
insertionSort = foldr insertion []

{-
insertionSort [3,2,4]
-> insertion 3 (insertion 2 (insertion 4 ([])))
-}
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Function Composition}
  \framesubtitle{Basics}

Let's abstract the composition of functions
\begin{code}
(.) :: (b -> c) -> (a -> b) -> (a -> c)
(.) f g = \x -> f (g x)
\end{code}
\vfill
Using the \verb+(.)+ function, we can compose function together
to create new ones:
\begin{code}
map :: (a -> b) -> [a] -> [b]
map fn = foldr ((:) . fn) []
-- (x:xs) == (:) x xs 
-- (:) . fn = \x -> (:) fn x
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Lazy Evaluation}
  \framesubtitle{Infinite Lists}
Haskell is a lazy language, meaning that the language will
evaluate expressions only one needed.
\begin{code}
iterate :: (a -> a) -> a -> [a]
iterate fn a = (a : iterate fn (fn a))

-- [a, fn a, fn (fn a), fn (fn (fn a))), ...]
\end{code}
This will do an infinite recursion, it will stop when algorithms
do not require more values from the infinite lists
\begin{code}
bitValues :: [Int]
bitValues = iterate (*2) 1

-- take 8 bitValues -> [1,2,4,8,16,32,64,128]
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Algebraic Data Types}
  \framesubtitle{Maybe Data Type}
  To handle \textit{nullable} values we use an Algebraic Data Type called \verb+Maybe+
\begin{code}
data Maybe a = Just a
             | Nothing
             deriving (Show)
\end{code}
  Where the \textit{a} in the \verb+Maybe+ could be any type (Int, String, Char) \\[0.5cm]
  Examples of values of type \verb+Maybe Int+ 
  \begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=0.2cm]
    \item \verb+Just 20+
    \item \verb+Nothing+
  \end{itemize}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Unfolds}

\begin{code}
unfoldr :: (a -> Maybe (b, a)) -> a -> [b]
unfoldr fn x = 
  case fn x of
    Just (a, b) -> a : (unfoldr fn b)
    Nothing -> []
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{From Int to [Bit]}
\begin{code}
type Bit = Int

nextBit :: Int -> Maybe (Bit, Int)
nextBit x 
  | x > 0 = Just (m, d)
  | otherwise = Nothing
  where
    d = x `div` 2
    m = x `mod` 2

toBinary :: Int -> [Bit]
toBinary = unfoldr nextBit
\end{code}
\end{frame}

\begin{frame}[containsverbatim]
  \frametitle{Binary to Decimal}
  \framesubtitle{Example of high-order functions, composability and infinite lists}
\begin{code}
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ _ [] = []
zipWith _ [] _ = []
zipWith fn (x:xs) (y:ys) = (fn x y) : zipWith fn xs ys

binaryToDecimal :: [Bit] -> Int
binaryToDecimal = sum . zipWith (*) bitValues
\end{code}
\end{frame}

\begin{frame}
  \frametitle{Why Haskell is not being used as much?}
  
  \begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=0.7cm]
    \item It's different, people is always afraid of what is different
    \item It's difficult, mostly related to the first point
    \item It's unpopular, mostly related to the first and second point 
    \item It's risky (for employers), there are not many Haskell developers to count on,
          of course this is mostly related to the first, second and third point
    \item Libraries are broad, but there is no depth (Many incompatible 
          experimental libraries that do the same thing)
  \end{itemize}

\end{frame}

\begin{frame}
  \begin{center}
  \Huge{Thank You!} \\[2cm]
  \normalsize{Get started at learnyouahaskell.com}\\
  \small{Github: http://github.com/roman/haskell\_meetup}\\
  \small{Twitter: @romanandreg}
  \end{center}
\end{frame}

\end{document}
