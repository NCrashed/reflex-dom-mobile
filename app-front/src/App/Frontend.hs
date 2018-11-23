module App.Frontend(
    frontend
  ) where

import Reflex.Dom

frontend :: DomBuilder t m => m ()
frontend = el "div" $ text "Welcome to Reflex"
