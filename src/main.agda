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

make-trie : 𝕃 string → trie int
make-trie [] = empty-trie
make-trie (x :: y :: ss) =
  let subtrie = make-trie ss
  in trie-insert subtrie x (int-from-nat (trie-size subtrie))
make-trie (_ :: ss) = make-trie ss

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
       let ss = getRandTexts (string-to-int "42" ) (string-to-int "10") (string-to-int "3") (string-to-int "10")
           t = make-trie ss
           joined = trie-to-string ", " int-to-string t
       in
       putStrLn joined >>
       -- putStrLn (int-to-string (computation-test-1 ss (make-trie ss))) >>
       return triv
