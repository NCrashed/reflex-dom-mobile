module App.Frontend(
    frontend
  ) where

import App.Shared
import Control.Monad.Fix
import Reflex.Dom

frontend :: (MonadHold t m, PostBuild t m, DomBuilder t m, MonadFix m) => m ()
frontend = do
  el "div" $ do
    el "h4" $ text "First counter"
    counter 0
  el "div" $ do
    el "h4" $ text "Second counter"
    counter 42

-- | Widget that contains from two buttons to increment and decrement value
counter :: (MonadHold t m, PostBuild t m, DomBuilder t m, MonadFix m) => Int -> m ()
counter v0 = elClass "div" "counter" $ mdo
  incE <- button "+"
  valD <- foldDyn ($) v0 $ leftmost [
      (\v -> v+1) <$ incE
    , (\v -> v-1) <$ decE
    ]
  dynText $ do
    val <- valD
    pure $ "Current value: " <> showt val
  decE <- button "-"
  pure ()
