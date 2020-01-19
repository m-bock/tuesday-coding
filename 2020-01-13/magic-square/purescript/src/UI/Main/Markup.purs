module UI.Main.Markup where

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
import UI.Main.Markup.Types (Styles)
import UI.Main.Control.Types (Action(..), State, Props)

mkRender :: Styles -> (Action -> Effect Unit) -> State -> Props -> JSX
mkRender style action state props =
  toBasic BaseUI.ui_wrapper
    { children:
      [ R.div
          $ style._root
              { children:
                [ R.div
                    $ style.item
                        { children:
                          [ UI.Edit.ui
                              { builders:
                                { value: state.builders
                                , onChange: action <<< SetBuilders
                                }
                              }
                          ]
                        }
                , R.div
                    $ style.item
                        { children:
                          [ maybe mempty
                              (\builders -> UI.View.ui { builders })
                              state.builders
                          ]
                        }
                ]
              }
      ]
    }
