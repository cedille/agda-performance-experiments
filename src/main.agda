module main where

open import lib
open import int
open import functions

postulate
  initializeStdinToUTF8 : IO ⊤
  setStdinNewlineMode : IO ⊤
  initRandGen : int → IO ⊤
  getRandTexts : int → int → int → int → 𝕃 string

{-# FOREIGN GHC {-# LANGUAGE TemplateHaskell #-} #-}
{-# FOREIGN GHC import qualified System.IO #-}
{-# FOREIGN GHC import qualified System.Random #-}
{-# FOREIGN GHC import qualified RandStrings #-}
{-# COMPILE GHC initializeStdinToUTF8 = System.IO.hSetEncoding System.IO.stdin System.IO.utf8 #-}
{-# COMPILE GHC setStdinNewlineMode = System.IO.hSetNewlineMode System.IO.stdin System.IO.universalNewlineMode #-}
{-# COMPILE GHC initRandGen = RandStrings.initRandGen #-}
{-# COMPILE GHC getRandTexts = RandStrings.getRandTexts #-}
-- {-# COMPILE GHC randomAlphaNum = \ n -> System.Random.setStdGen (System.Random.mkStdGen n) #-}

putStrLn : string → IO ⊤
putStrLn str = putStr str >> putStr "\n" 

make-trie : (trie int → string → int → trie int) → 𝕃 string → trie int
make-trie insert-fn [] = empty-trie
make-trie insert-fn (x :: y :: ss) =
  let subtrie = make-trie insert-fn ss
  in insert-fn subtrie x (int-from-nat (trie-size subtrie))
make-trie insert-fn (_ :: ss) = make-trie insert-fn ss

computation-test-1 : 𝕃 string → trie int → int
computation-test-1 [] t = int0
computation-test-1 (s :: ss) t with trie-lookup t s
computation-test-1 (s :: ss) t | nothing = computation-test-1 ss t
computation-test-1 (s :: ss) t | just v =
  let x = computation-test-1 ss t
  in v +int x

-- main entrypoint for the backend
main : IO ⊤
main = initializeStdoutToUTF8 >>
       initializeStdinToUTF8 >>
       setStdoutNewlineMode >>
       setStdinNewlineMode >>
       let ss = getRandTexts (string-to-int "42" ) (string-to-int "16") (string-to-int "3") (string-to-int "10")
           t1 = make-trie (trie-insert-safe{int}) ss
           joined1 = trie-to-string ", " int-to-string t1
           t2 = make-trie (trie-insert-fast{int}) ss
           joined2 = trie-to-string ", " int-to-string t2
       in
       putStrLn joined1 >>
       putStrLn "------------------" >>
       putStrLn joined2 >>
       -- putStrLn (int-to-string (computation-test-1 ss (make-trie ss))) >>
       return triv
