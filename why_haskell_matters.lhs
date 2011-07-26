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

\title{Haskell Quicky}
\author{Roman Gonzalez}
\institute{Vancouver Haskell Meetup}

\begin{document}

\ignore{\begin{code}
module Quicky where

\end{code}}


\begin{frame}
\titlepage
\end{frame}

\begin{frame}
  \frametitle{You can't get more functional than this \ldots}

  \begin{quotation}
    Haskell is a \emph{pure}, \emph{statically typed}, \emph{lazy}
    \emph{functional} programming language.
  \end{quotation}
  \vfill
  \begin{itemize}[label=\color{blue}{$\rightarrow$}, itemsep=2em]
    \item Name inspired by mathematician Haskell Brooks Curry
    \item Based on a more primitive language called \textit{Lambda Calculus}
  \end{itemize}
\end{frame}

% We are going to explain the concept of purity, we are not going to give
% any examples of pure and non-pure code given the time constraints.
\begin{frame}
  \frametitle{Purity}

  Functions can be specified to not have side effects, and the compiler
  will throw an error whenever you try to make a pure function do side 
  effects.\\[2\baselineskip]

  When using pure functions you can only use in the body of the function the 
  given input parameters, and they always must return a value.

  \vfill

  \footnotesize{* Functions that are not pure, can be easily 
          tracked down (easier to catch side effects bugs)}

\end{frame}

% We wont be explaining the benefits of staticaly typed languages
% this is something that is not only available on functional programming
% languages
\begin{frame}
  \frametitle{Statically Typed}

  The type system doesn't get in the way, the compiler is smart 
  enough to infer types for you when needed.
  

\end{frame}

% We are going to explain the concept of lazyness, but we won't give
% any example given time constraints
\begin{frame}
  \frametitle{Lazy}

  Haskell has lazy evaluation by default, you can get very powerful stuff like:
  \begin{itemize}
    \item Infinite Data Structures 
    \item Execution of statements only when really need it
  \end{itemize}

  However there are some woes:
  \begin{itemize}
    \item Difficult to know real code performance
    \item Memory can't get filled up with promises of execution when
  \end{itemize}
\end{frame}

% From now on, is just functions and code, we explain how 
% to call simple functions in Haskell, also how they behave
\begin{frame}[fragile]
  \frametitle{Simple Function}
\begin{code}%ignore code
    elem :: Char -> String -> Bool

    'e' `elem` "Hello" 
    --> True

    'b' `elem` "Hello"
    --> False

\end{code}
\end{frame}

% We implement a function using the elem function shown before
\begin{frame}[fragile]
  \frametitle{Simple Function Implementation}
\begin{code}
  isVowel :: Char -> Bool
  isVowel c = c `elem` "aeiou"
\end{code}
\begin{code}%ignore code
  isVowel 'a'
  --> True
  
  isVowel 'b'
  --> False
\end{code}
\end{frame}

% We re-implement the function just using partial evaluation
\begin{frame}[fragile]
  \frametitle{Partial Evaluation}
\begin{code}%ignore code
  (`elem` "aeiou") :: Char -> Bool

  (`elem` "aeiou") 'a'
  --> True
  
  (`elem` "aeiou") 'x'
  --> False

  isVowel :: Char -> Bool
  isVowel = (`elem` "aeiou")
\end{code}
\end{frame}

% We implement another function using the same function but with
% different partial evaluation
\begin{frame}[fragile]
  \frametitle{Partial Evaluation II} 
\begin{code}%ignore code
  ('a' `elem`) :: String -> Bool

  ('a' `elem`) "Contains"
  --> True

  ('a' `elem`) "Forget it"
  --> False

  containsA :: String -> Bool
  containsA = ('a' `elem`)
\end{code}
\end{frame}

% We implement another simple function that is using the not
\begin{frame}[fragile]
  \frametitle{Simple Function Implementation II}
\begin{code}
  isNotVowel :: Char -> Bool
  isNotVowel c = not (isVowel c)
\end{code}
\end{frame}

% We re-implement the same function using function composition, also
% we explain function composition definition
\begin{frame}[fragile]
  \frametitle{Function Composition}
\begin{code}%ignore code
  f . g = \c -> f (g c)

  isNotVowel :: Char -> Bool
  isNotVowel = not . isVowel
  -- the same as (\c -> not (isVowel c))
\end{code}
\end{frame}

% First version of removeVowels
\begin{frame}[fragile]
  \frametitle{removeVowels (1)}
\begin{code}
  removeVowels :: String -> String
  removeVowels str = filter isNotVowel str

\end{code}
\begin{code}%ignore code
  removeVowels "remove"
  --> "rmv"
\end{code}
\end{frame}

% We start to de-sugar all the code
\begin{frame}[fragile]
  \frametitle{removeVowels (2)}
  \texttt{filter isNotVowel} has already a type of \texttt{String -> String}, let's
  drop the input parameter all together.\\[2\baselineskip]
\begin{code}%ignore code
    removeVowels :: String -> String
    removeVowels = filter isNotVowel
\end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVowels (3)}
  \texttt{isNotVowel} is a pretty small function that is going to be used
  only once, drop the function declaration and just put the implementation
  on the filter function parameter.\\[2\baselineskip]

\begin{code}%ignore code
    removeVowels :: String -> String
    removeVowels = filter (not . isVowel)
\end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVowels (4)}
  \texttt{isVowel} is yet another small function that is going to be used
  only once, drop the function declaration and just put the 
  implementation.\\[2\baselineskip]

\begin{code}%ignore code
    removeVowels :: String -> String
    removeVowels = filter (not . (`elem` "aeiou"))
\end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVowels (5)}
\begin{code}%ignore code
    removeVowels str = filter isNotVowel str
    removeVowels = filter (not . isVowel)
    removeVowels = filter (not . (`elem` "aeiou"))
\end{code}
\end{frame}

\begin{frame}
  \frametitle{Quicky is over, but there is more}

  IO and Managed State using Monads\\
  Powerful Parser Combinators\\
  Compositional Input/Output (Iteratees)

\end{frame}

\begin{frame}
  \begin{center}
  \Huge{Thank You!} \\[2cm]
  \normalsize{Get started at learnyouahaskell.com and realworldhaskell.org/book}\\
  \small{Meetup: @vanhask}\\
  \small{Personal: @romanandreg}
  \end{center}
\end{frame}

\end{document}
