module Data.WrapNatural (WrapNatural, fromInt, toInt, main) where

import Prelude
import Control.Monad.Gen (chooseInt)
import Data.Foldable (for_)
import Data.Newtype (class Newtype, over2, unwrap, wrap)
import Data.Tuple (Tuple(..))
import Data.Typelevel.Num (class Nat, class Pos, D0, reifyInt, reifyIntP, toInt')
import Effect (Effect)
import Test.QuickCheck (class Arbitrary)
import Test.QuickCheck.Gen (randomSample)
import Test.QuickCheck.Laws.Data (checkBounded, checkCommutativeRing, checkRing, checkSemiring)
import Type.Proxy (Proxy(..))

-- Type
--
-- | A Natural number that wraps over at its boundaries.
-- | E.g:
-- | `WrapNatural D0 D4`
-- | `0 1 2 3 0 1 2 3 0 1 2 3 ...`
newtype WrapNatural offset size
  = WrapNatural Int

-- Instance
--
derive newtype instance _eq :: Eq (WrapNatural b1 b2)

derive newtype instance _ord :: Ord (WrapNatural b1 b2)

derive newtype instance _show :: Show (WrapNatural b1 b2)

derive instance _newtype :: Newtype (WrapNatural b1 b2) _

instance _arbitrary :: (Nat n1, Pos n2) => Arbitrary (WrapNatural n1 n2) where
  arbitrary = do
    let
      n1 = toInt' (Proxy :: Proxy n1)

      n2 = toInt' (Proxy :: Proxy n2)
    WrapNatural <$> chooseInt n1 (n1 + (n2 - 1))

instance _semiring :: (Nat b1, Pos b2) => Semiring (WrapNatural b1 b2) where
  add = performWrapped2 add
  zero = performWrapped zero
  mul = performWrapped2 mul
  one = performWrapped one

instance _commutativeRing ::
  (Nat b1, Pos b2, Bounded (WrapNatural b1 b2)) =>
  CommutativeRing (WrapNatural b1 b2)

instance _ring ::
  (Nat b1, Pos b2, Bounded (WrapNatural b1 b2)) =>
  Ring (WrapNatural b1 b2) where
  sub = performWrapped2 sub

instance _bounded ::
  (Nat b1, Pos b2) =>
  Bounded (WrapNatural b1 b2) where
  bottom = wrap $ toInt' (Proxy :: Proxy b1)
  top =
    wrap
      $ (toInt' (Proxy :: Proxy b1))
      + (toInt' (Proxy :: Proxy b2) - 1)

-- API
--
fromInt :: forall offset size. Nat offset => Pos size => Int -> WrapNatural offset size
fromInt n = performWrapped n

toInt :: forall offset size. WrapNatural offset size -> Int
toInt = unwrap

-- Util
--
performWrapped2 ::
  forall b1 b2.
  Nat b1 =>
  Pos b2 =>
  (Int -> Int -> Int) -> WrapNatural b1 b2 -> WrapNatural b1 b2 -> WrapNatural b1 b2
performWrapped2 f =
  over2 wrap
    ( \x1 x2 ->
        clampWrap' (Proxy :: Proxy b1) (Proxy :: Proxy b2) $ f x1 x2
    )

performWrapped ::
  forall b1 b2.
  Nat b1 =>
  Pos b2 =>
  Int -> WrapNatural b1 b2
performWrapped x = wrap (clampWrap' (Proxy :: Proxy b1) (Proxy :: Proxy b2) x)

clampWrap :: forall a. Ord a => EuclideanRing a => a -> a -> a -> a
clampWrap offset size value = offset + ((value - offset) `mod` size)

clampWrap' ::
  forall n1 n2.
  Nat n1 =>
  Pos n2 =>
  Proxy n1 -> Proxy n2 -> Int -> Int
clampWrap' offset size value = clampWrap (toInt' offset) (toInt' size) value

-- Test
--
main :: Effect Unit
main = do
  ns <- randomSample (chooseInt 0 5)
  ns' <- randomSample (chooseInt 1 5)
  for_ (Tuple <$> ns <*> ns')
    ( \(Tuple n1 n2) ->
        reifyIntP n2 (reifyInt n1 check)
    )
  where
  check ::
    forall n1 n2.
    Nat n1 =>
    Pos n2 =>
    n1 -> n2 -> Effect Unit
  check _ _ = do
    let
      proxy = Proxy :: Proxy (WrapNatural n1 n2)
    checkSemiring proxy
    checkRing proxy
    checkCommutativeRing proxy
    checkBounded proxy
