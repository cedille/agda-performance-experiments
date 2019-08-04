module RandStrings where

import System.Random
import Data.Text
-- import Char

initRandGen :: Int -> IO ()
initRandGen = \ n -> System.Random.setStdGen (System.Random.mkStdGen n)

randAlpha :: RandomGen g => g -> (Char, g)
randAlpha = randomR ('a', 'z')

randSingletonAlpha :: RandomGen g => g -> ([Char], g)
randSingletonAlpha g = ([a] , g')
  where
    (a , g') = randAlpha g

randomAs :: RandomGen g => Int -> (g -> (a, g)) -> g -> ([a], g)
randomAs n r g
  | n >= 1  = (a : rest, g'')
  | otherwise = ([] , g)
  where
    (a , g') = (r g)
    (rest , g'') = randomAs (n - 1) r g'

randAlphaString :: RandomGen g => Int -> g -> ([Char], g)
randAlphaString n = randomAs n randAlpha 
  -- | n >= 1  = (a : rest, g'')
  -- | otherwise = ([] , g)
  -- where
  --   (a , g') = (randAlpha g)
  --   (rest , g'') = randAlphaString (n - 1) g'
    
randAlphaText :: RandomGen g => Int -> g -> (Text, g)
randAlphaText n g = (pack s , g')
  where
    (s , g') = (randAlphaString n g)

randLengthAlphaText :: RandomGen g => Int -> Int -> g -> (Text, g)
randLengthAlphaText min max g = randAlphaText n g'
  where
    (n , g') = randomR (min, max) g
    
randAlphaTexts :: RandomGen g => Int -> Int -> Int -> g -> ([Text], g)
randAlphaTexts amt min max = randomAs amt (randLengthAlphaText min max)

getRandTexts :: Int -> Int -> Int -> Int -> [Text]
getRandTexts seed amt min max = fst (randAlphaTexts amt min max (mkStdGen seed))
