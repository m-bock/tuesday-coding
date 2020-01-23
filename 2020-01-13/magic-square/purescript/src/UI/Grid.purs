module UI.Grid (ui, Props) where

import Prelude
import Data.Array (mapWithIndex)
import Data.Maybe (Maybe, isJust, maybe)
import Data.Typelevel.Num as N
import Data.Vec (Vec, vec2)
import Data.Vec as Vec
import FitText (fitText)
import Matrix (Matrix)
import Matrix as Matrix
import React.Basic (JSX)
import React.Basic.DOM (css)
import React.Basic.DOM as DOM
import Record (union)
import Record as Record
import Util (PatchStyle, node, style_toProps, toBasic)

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
    , card ::
      { size :: Vec N.D2 Int
      , position :: Vec N.D2 Int
      , show :: Boolean
      , index :: Int
      } ->
      PatchStyle
    }

-- Markup
mkUi :: Env -> Props -> JSX
mkUi env props =
  let
    items = matrix_toArray props.matrix

    size = matrix_getSize props.matrix
  in
    node DOM.div
      (env.patch.root {})
      ( (applyRec render_cell { size } <$> items)
          <> ( mapWithIndex
                ( \index { value, position } ->
                    render_card { size, index, value, position }
                )
                items
            )
      )
  where
  applyRec f r1 r2 = f $ union r1 r2

  render_cell { size, position, value } =
    node DOM.div
      ( env.patch.cell
          { position, size }
          {}
      )
      []

  render_card { index, size, position, value } =
    node (toBasic fitText)
      { compressor: 0.3 }
      [ maybe
          (DOM.div {})
          ( \n ->
              node DOM.div
                ( env.patch.card
                    { show: isJust value
                    , position
                    , size
                    , index
                    }
                    {}
                )
                [ DOM.text $ show n ]
          )
          value
      ]

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
                  , background: "#e5e5e5"
                  , overflow: "hidden"
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
                  , left: calc $ calcPos (position Vec.!! N.d0) (size Vec.!! N.d0)
                  , top: calc $ calcPos (position Vec.!! N.d1) (size Vec.!! N.d1)
                  , width: calc $ calcSize (size Vec.!! N.d0)
                  , height: calc $ calcSize (size Vec.!! N.d1)
                  , borderLeft: "1px solid black"
                  , borderTop: "1px solid black"
                  --, boxSizing: "borderBox"
                  , zIndex: "0"
                  }
              }
                # style_toProps
            )
      )
    , card:
      ( \{ index, size, position } props ->
          let
            n = (size Vec.!! N.d0) * (size Vec.!! N.d1)
          in
            Record.union props
              ( { classNames: [ scope <> "card" ]
                , css:
                  css
                    { display: "flex"
                    , alignItems: "center"
                    , justifyContent: "center"
                    -- , opacity: if show then 1.0 else 0.0
                    -- , transition: "transform 1s"
                    , background: "white"
                    --, border: "5px solid red"
                    , boxSizing: "border-box"
                    , position: "absolute"
                    , left: calc $ calcPos (position Vec.!! N.d0) (size Vec.!! N.d0)
                    , top: calc $ calcPos (position Vec.!! N.d1) (size Vec.!! N.d1)
                    , width: calc $ calcSize (size Vec.!! N.d0) `calcSub` calcPx 1
                    , height: calc $ calcSize (size Vec.!! N.d1) `calcSub` calcPx 1
                    , marginTop: "1px"
                    , marginLeft: "1px"
                    , animationName: "cell"
                    , animationDuration: "1500ms" --show (1000.0 / toNumber n) <> "ms"
                    , zIndex: show (1000 - index)
                    , outline: "1px solid black"
                    }
                }
                  # style_toProps
              )
      )
    }

calcPos :: Int -> Int -> String
calcPos i n =
  show i
    `calcMul`
      (calcPct 100 `calcDiv` show n)

calcSize :: Int -> String
calcSize n = calcPct 100 `calcDiv` show n

calc :: String -> String
calc s = "calc" <> calcWrap s

calcDiv x y = calcWrap x <> " / " <> calcWrap y

calcMul x y = calcWrap x <> " * " <> calcWrap y

calcSub x y = calcWrap x <> " - " <> calcWrap y

calcPct x = show x <> "%"

calcPx x = show x <> "px"

calcWrap x = "(" <> x <> ")"
