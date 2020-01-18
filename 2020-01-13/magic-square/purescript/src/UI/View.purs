module UI.View where

import Prelude
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Maybe (Maybe(..))
import React.Basic.DOM as R
import Matrix (Matrix)
import React.Basic (Component, JSX, createComponent, element, make)
import Data.Array.NonEmpty as ArrayNE
import BaseUI.Card as BaseUI.Card
import Util (toBasic)

type Props
  = { builders :: NonEmptyArray (Matrix (Maybe Int))
    }

type State
  = {}

ui :: Props -> JSX
ui = make (createComponent "View") { initialState, render }
  where
  initialState :: State
  initialState = {}

  render self =
    toBasic BaseUI.Card.card
      { title: "Magic Square"
      , children:
        [ R.pre
            { children:
              [ R.text $ show $ ArrayNE.last self.props.builders
              ]
            }
        ]
      }
