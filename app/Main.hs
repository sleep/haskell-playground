module Main where

import Control.Monad
import Halive.Utils
import Language.Haskell.Interpreter
-- import Lib

myRead :: String -> IO [String]
myRead = readFile >=> return .lines

transform :: String -> String
transform xs = "> " ++  xs

myPrint :: [String] -> IO ()
myPrint = mapM_ (putStrLn . transform)

printReturn :: String -> IO String
printReturn xs = putStrLn xs >> return xs

main :: IO ()
-- main = myRead "test.hsplay" >>= \xss -> myPrint xss
main = do
  text <- reacquire 0 (printReturn "hello")
  xss <- myRead "test.hs"
  myPrint xss
