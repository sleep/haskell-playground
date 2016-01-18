module Main where

import Control.Monad
-- import Lib

myRead :: String -> IO [String]
myRead = readFile >=> return .lines

transform :: String -> String
transform xs = "> " ++  xs

myPrint :: [String] -> IO ()
myPrint = mapM_ (putStrLn . transform)


main :: IO ()
main = myRead "test.hsplay" >>= \xss -> myPrint xss
