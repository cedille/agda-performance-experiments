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

putStrsLn : 𝕃 string → IO ⊤
putStrsLn [] = return triv
putStrsLn (x :: l) = putStrLn x >> putStrsLn l

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

main : IO ⊤
main = initializeStdoutToUTF8 >>
       initializeStdinToUTF8 >>
       setStdoutNewlineMode >>
       setStdinNewlineMode >>
       let ss = getRandTexts (string-to-int "42" ) (string-to-int "12") (string-to-int "3") (string-to-int "10")
           -- t1 = make-trie (trie-insert-safe{int}) ss
           -- joined1 = trie-to-string ", " int-to-string t1
           -- t2 = make-trie (trie-insert-fast{int}) ss
           -- joined2 = trie-to-string ", " int-to-string t2
           t3 = make-trie (trie-insert-fast2{int}) ss
           joined3 = trie-to-string ", " int-to-string t3
           t3' = trie-remove-fast t3 "xzhnkawa"
           joined3' = trie-to-string ", " int-to-string t3'
           t3'' = trie-remove-fast t3 "xzhnkawaq"
           joined3'' = trie-to-string ", " int-to-string t3''
           t3''' = trie-remove t3'' "nuabu"
           joined3''' = trie-to-string ", " int-to-string t3'''
           t4 = trie-insert t3''' "cjmlsum-suffix" (string-to-int "384756")
           joined4 = trie-to-string ", " int-to-string t4
           t5 = trie-remove t4 "cjmlsum"
           joined5 = trie-to-string ", " int-to-string t5
           t6 = trie-insert t5 "cjmlsu" (string-to-int "3737373737373")
           joined6 = trie-to-string ", " int-to-string t6
           t7 = trie-remove t6 "cjmlsum" 
           joined7 = trie-to-string ", " int-to-string t7
           t8 = trie-remove t7 "cjmlsum-suffix" 
           joined8 = trie-to-string ", " int-to-string t8
           t9 = trie-remove (
                trie-remove (
                trie-remove t8 "lmsijyewj") "cjmlsu") "npoyvibq"
           joined9 = trie-to-string ", " int-to-string t9
           t10 = trie-insert t9 "gjzzblg" (string-to-int "48729797397")
           joined10 = trie-to-string ", " int-to-string t10
           t11 = trie-remove (
                 trie-remove t10 "gjzzblg") "gjzzblggto"
           joined11 = trie-to-string ", " int-to-string t11
           sep = "------------------"
           output = joined3 :: sep :: 
                    joined3' :: sep :: 
                    joined3'' :: sep :: 
                    joined3''' :: sep :: 
                    joined4 :: sep :: 
                    joined5 :: sep :: 
                    joined6 :: sep :: 
                    joined7 :: sep :: 
                    joined8 :: sep :: 
                    joined9 :: sep :: 
                    joined10 :: sep :: 
                    joined11 :: sep :: 
                    []
       in
       (putStrsLn output) >>
       return triv
