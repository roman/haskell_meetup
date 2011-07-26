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
module Quicky where

\end{code}}

\title{Haskell Quicky}
\author{Roman Gonzalez}
\institute{Vancouver Haskell Meetup}

\begin{document}

\begin{frame}
\titlepage
\end{frame}

\begin{frame}
  \frametitle{You can't get more functional than this...}

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

\begin{frame}[fragile]
  \frametitle{Simple Function Implementation}
  \begin{code}
  isVocal :: Char -> Bool
  isVocal c = c `elem` "aeiou"
  \end{code}
  \begin{code}%ignore code
  isVocal 'a'
  --> True
  
  isVocal 'b'
  --> False
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Partial Evaluation}
  \begin{code}%ignore code
  (`elem` "aeiou") :: Char -> Bool

  (`elem` "aeiou") 'a'
  --> True
  
  (`elem` "aeiou") 'x'
  --> False

  isVocal :: Char -> Bool
  isVocal = (`elem` "aeiou")
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Partial Evaluation II} 
  \begin{code}
  ('a' `elem`) :: String -> Bool

  ('a' `elem`) "Contains"
  --> True

  ('a' `elem`) "Forget it"
  --> False

  containsA :: String -> Bool
  containsA = ('a' `elem`)
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Simple Function Implementation II}
  \begin{code}
  isNotVocal :: Char -> Bool
  isNotVocal c = not (isVocal c)
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{Function Composition}
  \begin{code}%ignore code
  f . g = \c -> f (g c)
  
  isNotVocal :: Char -> Bool
  isNotVocal = not . isVocal
  -- the same as (\c -> not (isVocal c))
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVocals (1)}
  \begin{code}
    removeVocals :: String -> String
    removeVocals str = filter isNotVocal str

  \end{code}
  \begin{code}%ignore code
    removeVocals "remove"
    --> "rmv"
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVocals (2)}
  filter isNotVocal has already a type of \texttt{String -> String}, let's
  drop the input parameter all together.\\[2\baselineskip]
  \begin{code}%ignore code
    removeVocals :: String -> String
    removeVocals = filter isNotVocal
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVocals (3)}
  \texttt{isNotVocal} is a pretty small function that is going to be used
  only once, drop the function declaration and just put the implementation
  on the filter function parameter.\\[2\baselineskip]

  \begin{code}%ignore code
    removeVocals :: String -> String
    removeVocals = filter (not . isVocal)
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVocals (4)}
  \texttt{isVocal} is yet another small function that is going to be used
  only once, drop the function declaration and just put the 
  implementation.\\[2\baselineskip]

  \begin{code}%ignore code
    removeVocals :: String -> String
    removeVocals = filter (not . (`elem` "aeiou"))
  \end{code}
\end{frame}

\begin{frame}[fragile]
  \frametitle{removeVocals (5)}
  \begin{code}%ignore code
    removeVocals str = filter isNotVocal str
    removeVocals = filter (not . isVocal)
    removeVocals = filter (not . (`elem` "aeiou"))
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
