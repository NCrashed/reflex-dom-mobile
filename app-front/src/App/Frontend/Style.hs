module App.Frontend.Style(
    frontendCss
  , frontendCssBS
  ) where

import App.Frontend.Style.TH
import Clay
import Data.ByteString (ByteString)
import Data.ByteString.Lazy (toStrict)
import Data.Text.Lazy.Encoding (encodeUtf8)

frontendCssBS :: ByteString
frontendCssBS = let
  selfcss = toStrict . encodeUtf8 . renderWith compact [] $ frontendCss
  in milligramCss <> selfcss

frontendCss :: Css
frontendCss = do
  html ? textAlign center
  ".counter" |> button ? do
    marginRight (px 10)
    marginLeft  (px 10)
