module Main where

import App.Backend
import Data.Semigroup ((<>))
import Network.Wai.Handler.Warp
import Options.Applicative

data Options = Options {
  staticsPath :: FilePath
, listenPort  :: Port
}

options :: Parser Options
options = Options
  <$> strOption
      (  long "statics"
      <> metavar "STATICS_PATH"
      <> help "Folder with static HTML/CSS/JS to serve."
      <> value "../app-front/statics"
      <> showDefault )
  <*> option auto
      (  long "port"
      <> metavar "PORT_NUMBER"
      <> help "Which port the server listens."
      <> value 8080
      <> showDefault  )

main :: IO ()
main = app =<< execParser opts
  where
    opts = info (options <**> helper)
       ( fullDesc
      <> progDesc "Example of application backend server for reflex-dom"
      <> header "app-back - an example for reflex-dom application" )

app :: Options -> IO ()
app Options{..} = do
  putStrLn $ "Started listening on 127.0.0.1:" ++ show listenPort 
  run listenPort $ staticsApp staticsPath
