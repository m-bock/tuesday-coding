module UI.Anim (mkUi, Options, Props) where

import Prelude
import Data.Array.NonEmpty (NonEmptyArray)
import Data.Array.NonEmpty as ArrayNE
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Maybe (fromMaybe)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Timer (setInterval)
import React.Basic (JSX, Self, createComponent, make)

type Props a
  = { builders :: NonEmptyArray a }

type Options a
  = { ui_item :: { item :: a } -> JSX
    , interval :: Int
    }

type State
  = { index :: Int }

_index :: Lens' State Int
_index = prop (SProxy :: SProxy "index")

data Action
  = Increase
  | Reset

action :: forall a. Self (Props a) State -> Action -> Effect Unit
action self = case _ of
  Increase ->
    self.setState \state ->
      state { index = state.index + 1 }
  Reset ->
    self.setState \state ->
      state { index = 0 }

initialState :: State
initialState = { index: 0 }

mkUi :: forall a. Eq a => Options a -> Props a -> JSX
mkUi opts =
  make (createComponent "Anim")
    { initialState
    , render:
      ( \self ->
          render self.state self.props
      )
    , didMount:
      ( \self -> do
          -- TODO: Unsubscribe on unmount
          _ <- setInterval opts.interval (action self Increase)
          pure unit
      )
    , didUpdate:
      ( \self prev ->
          when (prev.prevProps /= self.props)
            (action self Reset)
      )
    }
  where
  render state props =
    opts.ui_item
      { item:
        fromMaybe (ArrayNE.last props.builders)
          (props.builders `ArrayNE.index` state.index)
      }
