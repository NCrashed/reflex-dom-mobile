module App.Backend(
    statics
  , staticsApp
  ) where

import Network.Wai
import Network.Wai.Middleware.Static
import Network.HTTP.Types (status404)

statics :: FilePath -> Middleware
statics dir = staticPolicy $ addBase dir

staticsApp :: FilePath -> Application
staticsApp dir = statics dir $ \_ sendResponse -> sendResponse $
  responseLBS status404 [("Content-Type", "text/plain")] "File not found"
