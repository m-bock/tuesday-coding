module Freeze where

import Prelude
import Effect (Effect)
import Effect.Class.Console (logShow)

foreign import data Frozen :: Type -> Type

foreign import freeze :: forall r. { | r } -> Frozen { | r }

foreign import someDangerousJS :: Frozen { age :: Int } -> { age :: Int }

main :: Effect Unit
main = logShow $ someDangerousJS (freeze { age: 3 })
