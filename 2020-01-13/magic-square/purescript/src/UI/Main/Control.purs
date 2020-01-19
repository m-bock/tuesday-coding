module UI.Main.Control (mkUI) where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import React.Basic (JSX, createComponent, make)
import UI.Main.Control.Types (Action(..), Props, State)

action :: _ -> Action -> Effect Unit
action self action = case action of
  SetBuilders builders -> self.setState _ { builders = Just builders }

initialState :: State
initialState = { builders: Nothing }

mkUI :: ((Action -> Effect Unit) -> State -> Props -> JSX) -> Props -> JSX
mkUI render =
  make (createComponent "Main")
    { initialState
    , render: \self -> render (action self) self.state self.props
    }
