module UI.Grid (ui, Props) where

import Prelude
import Data.Argonaut (toArray)
import Data.Maybe (Maybe, maybe)
import Data.Typelevel.Num as N
import Data.Vec (Vec, vec2)
import Data.Vec as Vec
import FitText (fitText)
import Matrix (Matrix)
import Matrix as Matrix
import Partial.Unsafe (unsafeCrashWith)
import React.Basic (JSX)
import React.Basic.DOM (CSS, css)
import React.Basic.DOM as DOM
import Record as Record
import Style.Debug (debugStyle)
import Util (Patch, PatchStyle, style_toProps, toBasic)
import Web.DOM.ParentNode (children)
import Web.HTML.HTMLProgressElement (position)

type Props
  = { matrix :: Matrix (Maybe Int) }

ui :: Props -> JSX
ui = mkUi env

env :: Env
env =
  { patch
  }

-- Markup.Type
--
type Env
  = { patch :: Patches
    }

type Patches
  = { root :: PatchStyle
    , cell ::
      { size :: Vec N.D2 Int
      , position :: Vec N.D2 Int
      } ->
      PatchStyle
    , card :: PatchStyle
    }

-- Markup
mkUi :: Env -> Props -> JSX
mkUi env props =
  DOM.div
    $ env.patch.root
        { children:
          matrix_toArray props.matrix
            <#> ( \{ position, value } ->
                  DOM.div
                    $ env.patch.cell
                        { position
                        , size: matrix_getSize props.matrix
                        }
                        { children:
                          [ toBasic fitText
                              { compressor: 0.3
                              , children:
                                [ DOM.div
                                    $ env.patch.card
                                        { children:
                                          [ maybe "" show value # DOM.text ]
                                        }
                                ]
                              }
                          ]
                        }
              )
        }
  where
  matrix_getSize mat = vec2 (Matrix.width mat) (Matrix.height mat)

  matrix_toArray mat =
    Matrix.toIndexedArray mat
      <#> (\{ x, y, value } -> { position: vec2 x y, value })

-- Styles
-- 
patch :: Patches
patch =
  let
    scope = "UI__Grid__"
  in
    { root:
      ( \props ->
          Record.union props
            ( { classNames: [ scope <> "table" ]
              , css:
                css
                  { position: "relative"
                  , width: "100%"
                  , height: "100%"
                  , borderRight: "1px solid black"
                  , borderBottom: "1px solid black"
                  }
              }
                # style_toProps
            )
      )
    , cell:
      ( \{ position, size } props ->
          Record.union props
            ( { classNames: []
              , css:
                css
                  { position: "absolute"
                  , left: "calc(" <> show (position Vec.!! N.d0) <> "*(100%/" <> show (size Vec.!! N.d0) <> "))"
                  , top: "calc(" <> show (position Vec.!! N.d1) <> "*(100%/" <> show (size Vec.!! N.d1) <> "))"
                  , width: "calc(100%/" <> show (size Vec.!! N.d0) <> ")"
                  , height: "calc(100%/" <> show (size Vec.!! N.d1) <> ")"
                  , borderLeft: "1px solid black"
                  , borderTop: "1px solid black"
                  }
              }
                # style_toProps
            )
      )
    , card:
      ( \props ->
          Record.union props
            ( { classNames: [ scope <> "card" ]
              , css:
                css
                  { display: "flex"
                  , alignItems: "center"
                  , justifyContent: "center"
                  }
              }
                # style_toProps
            )
      )
    }
