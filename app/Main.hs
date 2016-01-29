{-# LANGUAGE ExistentialQuantification, RankNTypes #-}


module Main where

import Control.Monad
import Control.Monad.Trans
import Halive.Utils
import Language.Haskell.Interpreter



main :: IO ()

main = do
  _ <- reacquire 0 (putStrLn "hello")
  putStrLn "\n"
  r <- runInterpreter test
  case r of
    Left err -> putStrLn $ "Oops..." ++ show err
    Right () -> putStrLn "\n"


test :: Interpreter ()
test = do
  loadModules ["app/Main.hs"]
  setTopLevelModules ["Main"]
  setImports ["Prelude"]
  say "Loading Main.hs"
  xss <- lift $ fmap lines (readFile "test.hs")
  mapM_ rep xss



rep:: String -> Interpreter ()
rep str = do
  say $ "> " ++ str
  result <- eval str
  typeof <- typeOf str
  say $ result ++ "\t\t"++ typeof ++ "\n"



say :: String -> Interpreter ()
say = liftIO . putStrLn


dup :: forall a. a -> [a]
dup x = [x, x]
