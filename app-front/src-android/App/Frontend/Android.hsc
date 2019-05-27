module App.Frontend.Android(  
    test_android
  ) where

#include "android.h"

foreign import ccall safe "test" test_android :: IO ()
