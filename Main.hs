module Main where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

import TS.Page.Theme


mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/src ResourceR Static resource
|]

getHomeR :: Handler Html
getHomeR =
    defaultLayout $ do
        pageTheme
        

main :: IO ()
main = do
    res <- static "Resources/"
    clubLst <- decodeFile "clubData.yaml"
    clubMap <- newIORef (clubsToMap $ fromJust clubLst)
    warp 80 App {clubM = clubMap, resource = res}
