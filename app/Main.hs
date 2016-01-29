{-# LANGUAGE ExistentialQuantification, RankNTypes #-}


module Main where

import Control.Monad
import Control.Monad.Trans
import DynFlags
import GHC
import GHC.Paths
import Unsafe.Coerce


main = defaultErrorHandler defaultFatalMessager defaultFlushOut $
  runGhc (Just libdir) $ do
    return ()
