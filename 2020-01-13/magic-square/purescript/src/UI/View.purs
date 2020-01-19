module UI.View (ui) where

import Prelude
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Maybe (Maybe(..))
import React.Basic.DOM as R
import Matrix (Matrix)
import React.Basic (Component, JSX, createComponent, element, make)
import Data.Array.NonEmpty as ArrayNE
import BaseUI.Card as BaseUI.Card
import Util (toBasic)
import BaseUI.AspectRatioBox as BaseUI.AspectRatioBox
import Util (Patch)
import Record as Record

ui :: Ui
ui = mkUi $ mkRender styles

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

-- Markup
--
mkRender :: Styles -> Render
mkRender styles props =
  toBasic BaseUI.Card.card
    { title: "Magic Square"
    , children:
      [ toBasic BaseUI.AspectRatioBox.aspectRatioBox
          { children:
            [ toBasic BaseUI.AspectRatioBox.aspectRatioBoxBody
                { children:
                  [ R.div
                      $ styles.square
                          { children:
                            [ R.pre
                                { children:
                                  [ R.text $ show $ ArrayNE.last props.builders
                                  ]
                                }
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

styles :: Styles
styles =
  let
    scope = "UI__View__"
  in
    { square:
      ( \props ->
          Record.merge props { className: scope <> "square" }
      )
    }
