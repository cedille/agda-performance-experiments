module main where

open import lib
open import int

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

-- main entrypoint for the backend
main : IO ⊤
main = initializeStdoutToUTF8 >>
       initializeStdinToUTF8 >>
       setStdoutNewlineMode >>
       setStdinNewlineMode >>
       let ss = getRandTexts (string-to-int "42" ) (string-to-int "10") (string-to-int "3") (string-to-int "10")
           joined = string-concat-sep ",\n" ss in
       putStrLn joined >>
       return triv
