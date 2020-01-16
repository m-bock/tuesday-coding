module Data.WrapInt (WrapInt, fromInt, toInt) where

import Prelude
import Control.Monad.Gen (chooseInt)
import Data.Foldable (for_)
import Data.Newtype (class Newtype, over2, unwrap, wrap)
import Data.Tuple (Tuple(..))
import Data.Typelevel.Num (class Nat, reifyInt, toInt')
import Effect (Effect)
import Test.QuickCheck (class Arbitrary)
import Test.QuickCheck.Gen (randomSample)
import Test.QuickCheck.Laws.Data (checkBounded, checkCommutativeRing, checkRing, checkSemiring)
import Type.Proxy (Proxy(..))

-- Type
--
newtype WrapInt offset size
  = WrapInt Int

-- Instance
--
derive newtype instance eq_WrapInt :: Eq (WrapInt b1 b2)

derive newtype instance ord_WrapInt :: Ord (WrapInt b1 b2)

derive newtype instance show_WrapInt :: Show (WrapInt b1 b2)

derive instance newtype_WrapInt :: Newtype (WrapInt b1 b2) _

instance arbitrary_WrapInt :: (Nat n1, Nat n2) => Arbitrary (WrapInt n1 n2) where
  arbitrary = do
    let
      n1 = toInt' (Proxy :: Proxy n1)

      n2 = toInt' (Proxy :: Proxy n2)
    WrapInt <$> chooseInt n1 (n1 + n2)

instance semiring_WrapInt :: (Nat b1, Nat b2) => Semiring (WrapInt b1 b2) where
  add = performWrapped2 add
  zero = performWrapped zero
  mul = performWrapped2 mul
  one = performWrapped one

instance commutativeRing_WrapInt ::
  (Nat b1, Nat b2, Bounded (WrapInt b1 b2)) =>
  CommutativeRing (WrapInt b1 b2)

instance ring_WrapInt ::
  (Nat b1, Nat b2, Bounded (WrapInt b1 b2)) =>
  Ring (WrapInt b1 b2) where
  sub = performWrapped2 sub

instance bounded_WrapInt ::
  (Nat b1, Nat b2) =>
  Bounded (WrapInt b1 b2) where
  bottom = wrap $ toInt' (Proxy :: Proxy b1)
  top = wrap $ (toInt' (Proxy :: Proxy b1)) + (toInt' (Proxy :: Proxy b2))

-- API
--
fromInt :: forall offset size. Nat offset => Nat size => Int -> WrapInt offset size
fromInt n = performWrapped n

toInt :: forall offset size. WrapInt offset size -> Int
toInt = unwrap

-- Util
--
performWrapped2 ::
  forall b1 b2.
  Nat b1 =>
  Nat b2 =>
  (Int -> Int -> Int) -> WrapInt b1 b2 -> WrapInt b1 b2 -> WrapInt b1 b2
performWrapped2 f =
  over2 wrap
    ( \x1 x2 ->
        clampWrap' (Proxy :: Proxy b1) (Proxy :: Proxy b2) $ f x1 x2
    )

performWrapped ::
  forall b1 b2.
  Nat b1 =>
  Nat b2 =>
  Int -> WrapInt b1 b2
performWrapped x = wrap (clampWrap' (Proxy :: Proxy b1) (Proxy :: Proxy b2) x)

clampWrap :: forall a. Ord a => EuclideanRing a => a -> a -> a -> a
clampWrap offset size value = offset + ((value - offset) `mod` (size + one))

clampWrap' ::
  forall n1 n2.
  Nat n1 =>
  Nat n2 =>
  Proxy n1 -> Proxy n2 -> Int -> Int
clampWrap' offset size value = clampWrap (toInt' offset) (toInt' size) value

-- Test
--
test :: Effect Unit
test = do
  ns <- randomSample (chooseInt 0 5)
  for_ (Tuple <$> ns <*> ns)
    ( \(Tuple n1 n2) ->
        reifyInt n2 (reifyInt n1 check)
    )
  where
  check ::
    forall n1 n2.
    Nat n1 =>
    Nat n2 =>
    n1 -> n2 -> Effect Unit
  check _ _ = do
    let
      proxy = Proxy :: Proxy (WrapInt n1 n2)
    checkSemiring proxy
    checkRing proxy
    checkCommutativeRing proxy
    checkBounded proxy
