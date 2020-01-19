module UI.View (ui) where

import Prelude
import BaseUI.AspectRatioBox as BaseUI.AspectRatioBox
import BaseUI.Card as BaseUI.Card
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as ArrayNE
import Data.Maybe (Maybe(..))
import Matrix (Matrix)
import React.Basic (Component, JSX, createComponent, element, make)
import React.Basic.DOM as R
import Record as Record
import UI.Grid as UI.Grid
import Util (Patch)
import Util (toBasic)

ui :: Ui
ui =
  mkUi
    $ mkRender
        { patch
        , ui_grid: UI.Grid.ui
        }

-- Control.Types
-- 
type Ui
  = Props -> JSX

type Props
  = { builders :: NonEmptyArray (Matrix (Maybe Int))
    }

type State
  = {}

type Render
  = Props -> JSX

-- Control
--
mkUi :: Render -> Ui
mkUi render =
  make (createComponent "View")
    { initialState
    , render: \self -> render self.props
    }

initialState :: State
initialState = {}

-- Markup.Types
--
type Styles
  = { square :: Patch ( className :: String ) }

type Options
  = { patch :: Styles
    , ui_grid :: { matrix :: Matrix (Maybe Int) } -> JSX
    }

-- Markup
--
mkRender :: Options -> Render
mkRender options@{ patch } props =
  toBasic BaseUI.Card.card
    { title: "Magic Square"
    , children:
      [ toBasic BaseUI.AspectRatioBox.aspectRatioBox
          { children:
            [ toBasic BaseUI.AspectRatioBox.aspectRatioBoxBody
                { children:
                  [ R.div
                      $ patch.square
                          { children:
                            [ options.ui_grid { matrix: ArrayNE.last props.builders }
                            ]
                          }
                  ]
                }
            ]
          }
      ]
    }

-- Styles
--
foreign import css :: Unit

patch :: Styles
patch =
  let
    scope = "UI__View__"
  in
    { square:
      ( \props ->
          Record.union props { className: scope <> "square" }
      )
    }
