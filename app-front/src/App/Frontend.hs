module App.Frontend(
    frontend
  ) where

import App.Shared
import Control.Monad.Fix
import Data.Text (Text)
import Reflex.Dom

frontend :: MonadWidget t m => m ()
frontend = todo
  -- el "div" $ do
  --   el "h4" $ text "First counter"
  --   counter 0
  -- el "div" $ do
  --   el "h4" $ text "Second counter"
  --   counter 42

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

todo :: forall t m . MonadWidget t m => m ()
todo = mdo
  itemsD :: Dynamic t [Text] <- el "div" $ do
    strD :: Dynamic t Text <- textField
    addE :: Event t Text <- tag (current strD) <$> button "Add"
    foldDyn ($) [] $ leftmost [
        (:) <$> addE
      , (\a -> filter (/= a)) <$> switch (current delED) ]
  delED :: Dynamic t (Event t Text) <- widgetHoldDyn $ ffor itemsD $ \items ->
    fmap leftmost . flip traverse items $ \item -> el "div" $ do
      text item
      e <- button "Done"
      pure $ item <$ e
  pure ()

textField :: MonadWidget t m => m (Dynamic t Text)
textField = fmap _textInput_value $ textInput def

widgetHoldDyn :: MonadWidget t m => Dynamic t (m a) -> m (Dynamic t a)
widgetHoldDyn md = do
  m0 <- sample . current $ md
  widgetHold m0 $ updated md
