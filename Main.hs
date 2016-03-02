module Main where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

import TS.Page.Theme
import TS.Page.Home
import TS.Page.Caesar


mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/src ResourceR Static src
|]

getCaesarR :: Handler Html
getCaesarR = do
    f <- generateFormPost caesarForm
    defaultLayout $ do
        pageTheme
        caesarWidget f

postCResultR :: Handler Html
postCResultR = do
    ((result, _), _) <- runFormPost caesarForm
    case result of
        FormSuccess sub ->
            defaultLayout $ do
                pageTheme
                submitSuccess sub

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
        pageTheme
        homePage

main :: IO ()
main = do
    res <- static "Resources/"
    warp 80 TS {src = res}
