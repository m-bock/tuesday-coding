module UI.View (ui) where

import Prelude
import BaseUI.AspectRatioBox as BaseUI.AspectRatioBox
import BaseUI.Card as BaseUI.Card
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Maybe (Maybe, maybe)
import Matrix (Matrix)
import React.Basic (JSX, createComponent, make)
import Record as Record
import UI.Anim as UI.Anim
import UI.Grid as UI.Grid
import Util (Patch, node)
import Util (toBasic)

ui :: Ui
ui = mkUi $ mkRender options

options :: Options
options =
  { styles
  , ui_builders:
    UI.Anim.mkUi
      { ui_item:
        \{ item } -> UI.Grid.ui { matrix: item }
      , interval: 500
      }
  , copy
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
type Options
  = { styles :: Styles
    , ui_builders :: { builders :: NonEmptyArray (Matrix (Maybe Int)) } -> JSX
    , copy :: Copy
    }

type Styles
  = { square :: Patch ( className :: String )
    , box :: Patch ( width :: String )
    }

type Copy
  = { title :: String
    }

-- Markup
mkRender :: Options -> Render
mkRender opts props =
  node (BaseUI.Card.card # toBasic)
    { title: opts.copy.title
    }
    [ node (BaseUI.AspectRatioBox.aspectRatioBox # toBasic)
        (opts.styles.box {})
        [ node (BaseUI.AspectRatioBox.aspectRatioBoxBody # toBasic)
            {}
            [ opts.ui_builders
                { builders: props.builders
                }
            ]
        ]
    ]

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
          Record.union props { className: scope <> "square" }
      )
    , box:
      ( \props ->
          Record.union props { width: "100%" }
      )
    }

-- Copy
--
copy :: Copy
copy = { title: "Magic Square" }
