module Main where

import Prelude
import Effect (Effect)
import React.Basic.DOM as R
import UI.Main as UI.Main
import Web.DOM as Web.DOM

foreign import __esModule :: Boolean

foreign import mountApp :: (Web.DOM.Element -> Effect Unit) -> Effect Unit

main :: Effect Unit
main = do
  mountApp \element -> do
    R.render (UI.Main.ui {}) element
  pure unit
