module MagicSquare.OddNatural where

import Prelude
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as ArrayNE
import Data.Matrix (replicate') as Matrix
import Data.Matrix.Extra (lookup, set) as Matrix
import Data.Maybe (Maybe(..))
import Data.Typelevel.Num (class DivMod, class Pos, D0, D1, D2, d1, d3, d5, d7, toInt, toInt')
import Data.Typelevel.Undefined (undefined)
import Data.Vec (Vec, vec2)
import Data.WrapNatural (WrapNatural)
import Data.WrapNatural as WrapNatural
import Debug.Trace (spy)
import Effect (Effect)
import MagicSquare (MagicSquare_Builder)
import MagicSquare as MagicSquare
import Test.Unit (TestSuite, suite)
import Test.Unit.Main (runTest)
import Type.Proxy (Proxy(..))

-- fromOddNatural
--
solve_steps ::
  forall n.
  Pos n =>
  Odd n =>
  n -> NonEmptyArray (MagicSquare_Builder n)
solve_steps _ =
  go
    { builders: ArrayNE.singleton $ Matrix.replicate' Nothing
    , position: vec2 (WrapNatural.fromInt $ n / 2) (WrapNatural.fromInt 0)
    , index: 1
    }
  where
  n = toInt' (Proxy :: Proxy n)

  go ::
    { builders :: NonEmptyArray (MagicSquare_Builder n)
    , position :: Vec D2 (WrapNatural D0 n)
    , index :: Int
    } ->
    NonEmptyArray (MagicSquare_Builder n)
  go { index, builders }
    | index > (n * n) = builders

  go { builders, position, index } =
    let
      builder = ArrayNE.last builders
    in
      case next position builder of
        Just posNext ->
          go
            { builders: ArrayNE.snoc builders (Matrix.set posNext (Just index) builder)
            , position: posNext
            , index: index + 1
            }
        Nothing -> builders

solve :: forall n. Pos n => Odd n => n -> MagicSquare_Builder n
solve = solve_steps >>> ArrayNE.head

next ::
  forall s.
  Pos s =>
  Vec D2 (WrapNatural D0 s) -> MagicSquare_Builder s -> Maybe (Vec D2 (WrapNatural D0 s))
next pos builder =
  [ vec2 1 (-1)
  , vec2 0 1
  ]
    <#> (map WrapNatural.fromInt)
    <#> (pos + _)
    # Array.find isFree
  where
  isFree :: Vec D2 (WrapNatural D0 s) -> Boolean
  isFree posNext = case Matrix.lookup posNext builder of
    Just _ -> false
    Nothing -> true

test' :: TestSuite
test' =
  suite "OddNatural" do
    reify d1
    reify d3
    reify d5
    reify d7
  where
  reify :: forall n. Pos n => Odd n => n -> TestSuite
  reify n = do
    suite ("For natural " <> (show $ toInt (undefined :: n))) do
      MagicSquare.test' (solve n)

-- Odd
--
class Odd n

instance odd :: (DivMod n D2 trash D1) => Odd n

-- Main
--
main :: Effect Unit
main =
  runTest do
    test'
