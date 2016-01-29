{-# LANGUAGE ExistentialQuantification, RankNTypes #-}


module Main where

import Control.Monad
import Control.Monad.Trans
import Halive.Utils
import Language.Haskell.Interpreter



main :: IO ()

main = do
  _ <- reacquire 0 (putStrLn "hello")

  putStr "\ESC[2J"

  xss <- fmap lines (readFile "test.hs")
  mapM_ rep xss


run :: Interpreter a -> IO (Either InterpreterError a)

run x = runInterpreter $ do
  loadModules ["app/Main.hs"]
  setTopLevelModules ["Main"]
  setImports ["Prelude", "Text.Show.Pretty"]
  x



altEval :: String -> IO (Either InterpreterError (Maybe String, String))
altEval str = do
  result <- run $ evalAndTypeOf str
  case result of
    Left err -> do
      result <- run $ coolTypeOf str
      case result of
        Left err -> return $ Left err
        Right result -> return $ Right result
    Right result -> return $ Right result
  where
    coolTypeOf str = do
      typeof <- typeOf str
      return (Nothing, typeof)
    evalAndTypeOf str = do
      output <- eval $ str
      typeof <- typeOf str
      return (Just output, typeof)


rep :: String -> IO ()
rep str = do
  result <- altEval str
  case result of
    Left _ -> return ()
    Right (l, r) -> do
      putStrLn $ "λ: " ++ str
      case l of
        Just l -> putStrLn l
        Nothing -> return ()
      putStrLn $ "" ++ r ++ "\n\n\n"



say :: String -> Interpreter ()
say = liftIO . putStrLn


dup :: forall a. a -> [a]
dup x = [x, x, x]
