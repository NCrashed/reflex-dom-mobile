module App.Shared(
    (<>)
  , showt
  ) where

import Data.Semigroup ((<>))
import Data.Text (Text, pack)

showt :: Show a => a -> Text
showt = pack . show 
