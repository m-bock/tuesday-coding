module MagicSquare where

import Prelude
import Data.Foldable (find, findMap)
import Data.Lens.Indexed (positions)
import Data.Matrix (Matrix)
import Data.Matrix as Matrix
import Data.Matrix.Extra (lookup)
import Data.Maybe (Maybe(..))
import Data.Typelevel.Num (class DivMod, class Nat, class Pos, class Pred, class Succ, D0, D1, D2, d0, d1, toInt')
import Data.Vec (Vec, vec2, (!!))
import Data.WrapInt (WrapInt)
import Data.WrapInt as WrapInt
import Partial.Unsafe (unsafeCrashWith, unsafePartial)
import Type.Proxy (Proxy(..))

newtype MagicSquare s
  = MagicSquare (Matrix s s Int)

type MagicSquare_Builder s
  = Matrix s s (Maybe Int)

toMatrix :: forall s. MagicSquare s -> Matrix s s Int
toMatrix (MagicSquare mat) = mat

--
--
--fromBuilder :: forall s. MagicSquare_Builder s -> Either Error MagicSquare s
-- Odd
--
class Odd n

instance odd :: (DivMod n D2 trash D1) => Odd n
 {-
fromOddNatural ::
  forall n max.
  Pos n =>
  Succ max n =>
  Odd n =>
  n -> MagicSquare n
fromOddNatural _ =
  let
    n = toInt' (Proxy :: Proxy n)
  in
    go
      { builder: Matrix.replicate' Nothing
      , position: vec2 (WrapInt.fromInt $ n / 2) (WrapInt.fromInt 0)
      , index: 1
      }
  where
  go ::
    { builder :: MagicSquare_Builder n
    , position :: Vec D2 (WrapInt D0 max)
    , index :: Int
    } ->
    MagicSquare n
  go { builder, position, index }
    | lookup position builder == Nothing =
      go
        { builder: insert position (Just index) builder
        , position: next position builder
        , index: index + 1
        }

next ::
  forall s max a.
  Succ max s =>
  Vec D2 (WrapInt D0 max) -> Matrix s s (Maybe a) -> Maybe (Vec D2 (WrapInt s s))
next pos builder =
  [ vec2 1 2
  , vec2 0 1
  ]
    <#> (pos + _)
    # find isFree
  where
  isFree :: Vec D2 (WrapInt D0 max) -> Boolean
  isFree posNext = case lookup posNext builder of
    Just _ -> false
    Nothing -> true
-}