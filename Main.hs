module Main where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

import TS.Page.Theme


mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/src ResourceR Static src
|]

getHomeR :: Handler Html
getHomeR =
    defaultLayout $ do
        pageTheme


main :: IO ()
main = do
    res <- static "Resources/"
    warp 80 TS {src = res}
