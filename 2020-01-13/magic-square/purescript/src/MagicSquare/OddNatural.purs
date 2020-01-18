module MagicSquare.OddNatural (solve, solve_steps, solve_steps', class Odd) where

import Prelude
import Data.Array as Array
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as ArrayNE
import Data.Matrix (Matrix(..), replicate') as Matrix
import Data.Matrix.Extra (lookup, set, toUntyped) as Matrix
import Data.Maybe (Maybe(..))
import Data.Typelevel.Num (class DivMod, class Pos, D0, D1, D2, d1, d3, d5, d7, reifyIntP, toInt, toInt')
import Data.Typelevel.Undefined (undefined)
import Data.Vec (Vec, vec2)
import Data.WrapNatural (WrapNatural)
import Data.WrapNatural as WrapNatural
import Effect (Effect)
import MagicSquare (MagicSquare_Builder)
import MagicSquare as MagicSquare
import Test.Unit (TestSuite, suite)
import Test.Unit.Main (runTest)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)
import Matrix as MatrixUntyped

--
reifyOddPos :: forall r. Int -> (forall n. Pos n => Odd n => n -> r) -> Maybe r
reifyOddPos i f =
  if i `mod` 2 == 0 then
    Nothing
  else
    Just (reifyIntP i (relaxOdd' f {}))
  where
  relaxOdd' :: forall n. (Odd n => (n -> r)) -> {} -> n -> r
  relaxOdd' = unsafeCoerce

--
solve :: forall n. Pos n => Odd n => n -> MagicSquare_Builder n
solve = solve_steps >>> ArrayNE.head

solve_steps' :: Int -> Maybe (NonEmptyArray (MatrixUntyped.Matrix (Maybe Int)))
solve_steps' n = reifyOddPos n (solve_steps >>> map Matrix.toUntyped)

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

  go { builders, index, position } =
    let
      builder = ArrayNE.last builders
    in
      case next position builder of
        Just next_position ->
          let
            next_builders =
              Matrix.set next_position (Just index) builder
                # ArrayNE.snoc builders

            next_index = index + 1
          in
            go
              { builders: next_builders
              , position: next_position
              , index: next_index
              }
        Nothing -> builders

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
