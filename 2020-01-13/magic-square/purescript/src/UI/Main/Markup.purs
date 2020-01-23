module UI.Main.Markup where

import Prelude
import BaseUI as BaseUI
import Data.Maybe (maybe)
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.DOM as R
import UI.Edit as UI.Edit
import UI.View as UI.View
import Util (toBasic)
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
