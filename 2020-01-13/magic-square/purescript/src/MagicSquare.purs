module MagicSquare where

import Prelude
import Data.Array as Array
import Data.Foldable (all, foldr, sum)
import Data.FoldableWithIndex (forWithIndex_)
import Data.Matrix (Matrix)
import Data.Matrix as Matrix
import Data.Matrix.Extra as Matrix
import Data.Maybe (Maybe(..), fromJust, fromMaybe)
import Data.Set as Set
import Data.String as String
import Data.Typelevel.Num (class DivMod, class Lt, class Nat, class Pos, class Succ, D0, D1, D2, d0, d1, d3, d5, d7, toInt, toInt')
import Data.Typelevel.Undefined (undefined)
import Data.Vec (Vec, vec2)
import Data.Vec as Vec
import Data.WrapNatural (WrapNatural)
import Data.WrapNatural as WrapNatural
import Effect (Effect)
import Partial.Unsafe (unsafePartial)
import Prelude as String
import Test.QuickCheck (Result, withHelp, (===))
import Test.Unit (Test, TestSuite, suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.QuickCheck (quickCheck)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

newtype MagicSquare s
  = MagicSquare (MagicSquare_Spec s)

type MagicSquare_Spec s
  = { matrix :: MagicSquare_Matrix s
    , magicNumber :: Int
    }

type MagicSquare_Matrix s
  = Matrix s s Int

type MagicSquare_Builder s
  = Matrix s s (Maybe Int)

toSpec :: forall s. MagicSquare s -> MagicSquare_Spec s
toSpec (MagicSquare spec) = spec

test' :: forall s. Pos s => MagicSquare_Builder s -> TestSuite
test' matrix =
  let
    size = toInt (undefined :: s)

    magicNumber =
      Matrix.diagonal_main matrix
        # map (fromMaybe 0)
        # sum
  in
    suite "Sum Up" do
      suite "Columns" do
        forWithIndex_ (Matrix.columns matrix # Vec.toArray)
          ( \i x ->
              test ("Column at index " <> show i) do
                quickCheck $ checkSumUp magicNumber x
          )
        suite "Rows" do
          forWithIndex_ (Matrix.rows matrix # Vec.toArray)
            ( \i x ->
                test ("Row at index " <> show i) do
                  quickCheck $ checkSumUp magicNumber x
            )
        test "Main Diagonal" do
          quickCheck
            ( checkSumUp magicNumber (Matrix.diagonal_main matrix)
            )
        test "Counter Diagonal" do
          quickCheck
            ( checkSumUp magicNumber (Matrix.diagonal_counter matrix)
            )
      test "All numbers" do
        quickCheck
          ( let
              actual = foldr Set.insert Set.empty matrix

              expected =
                Array.range 1 (size * size)
                  <#> Just
                  # Set.fromFoldable
            in
              Set.difference actual expected === Set.empty
          )
  where
  checkSumUp :: Int -> Vec s (Maybe Int) -> Result
  checkSumUp magicNumber vec =
    let
      vec' = map (fromMaybe 0) vec
    in
      (sum vec' == magicNumber)
        `withHelp`
          ( [ [ "Does not sum up to magic number", show magicNumber, "." ]
            , [ show vec' ]
            ]
              <#> String.joinWith " "
              # String.joinWith "\n"
          )
