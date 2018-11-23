module Main where

import App.Frontend
import App.Frontend.Style
import Reflex.Dom

main :: IO ()
main = mainWidgetWithCss frontendCssBS frontend
