module UI.Main where

import Prelude
import BaseUI as BaseUI
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Matrix (Matrix)
import React.Basic (Component, JSX, createComponent, element, make)
import React.Basic.DOM as R
import UI.Edit as UI.Edit
import UI.View as UI.View
import Util (toBasic, Patch)
import React.Basic.DOM.Internal (CSS, css)
import Data.Maybe (fromMaybe)
import Record as Record
import Prim.Row (class Union, class Nub)
import React.Basic.DOM.Generated (Props_div)

type Props
  = { 
    }

type State
  = { builders :: Maybe (NonEmptyArray (Matrix (Maybe Int)))
    }

data Action
  = SetBuilders (NonEmptyArray (Matrix (Maybe Int)))

action :: _ -> Action -> Effect Unit
action self action = case action of
  SetBuilders builders -> self.setState _ { builders = Just builders }

ui' :: Styles -> Props -> JSX
ui' style = make (createComponent "Main") { initialState, render }
  where
  initialState :: State
  initialState = { builders: Nothing }

  render self@{ props } =
    toBasic BaseUI.ui_wrapper
      { children:
        [ R.div
            $ style._root props
                { children:
                  [ R.div
                      $ style.item props
                          { children:
                            [ UI.Edit.ui
                                { builders:
                                  { value: self.state.builders
                                  , onChange: action self <<< SetBuilders
                                  }
                                }
                            ]
                          }
                  , R.div
                      $ style.item props
                          { children:
                            [ maybe mempty
                                (\builders -> UI.View.ui { builders })
                                self.state.builders
                            ]
                          }
                  ]
                }
        ]
      }

type Styles
  = ( { _root :: Props -> Patch ( className :: String )
      , item :: Props -> Patch ( className :: String )
      }
    )

styles :: Styles
styles =
  { _root:
    ( \props_self props ->
        Record.merge props { className: "UI__Main__root" }
    )
  , item:
    ( \props_self props ->
        Record.merge props { className: "item" }
    )
  }

ui :: Props -> JSX
ui = ui' styles
