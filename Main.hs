module Main where
import qualified Data.ByteString.Char8 as BS
import TS.Logic
import TS.Utils
import TS.App
import Yesod

import TS.Page.Theme
import TS.Page.Home
import TS.Page.Caesar
import TS.Page.YoYo
import TS.Page.PRAC
import TS.Page.PRACResults

mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/praClubs PRAR GET
/praClubs/submitted PRASR POST
/praClubs/results PRARR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

getPRAR :: Handler Html
getPRAR = do
    TS {..} <- getYesod
    clubMap <- liftIO $ readIORef clubM
    f <- generateFormPost (studentForm clubMap)
    defaultLayout $ do
        praTheme
        formWidget f

postPRASR :: Handler Html
postPRASR = do
    TS {..} <- getYesod
    clubMap <- liftIO $ readIORef clubM
    ((result, widget), enctype) <- runFormPost (studentForm clubMap)
    case result of
        FormSuccess fStudent -> do
            liftIO $ BS.appendFile "Resources/sdntData.yaml" (encode [fStudent])
            defaultLayout $ do
                praTheme
                pracSubmitSuccess

getPRARR :: Handler Html
getPRARR = do
    TS {..} <- getYesod
    clubMap <- liftIO $ readIORef clubM
    sdntData <- liftIO $ return . failYaml =<< decodeFileEither "Resources/sdntData.yaml"
    defaultLayout $ do
        praTheme
        resultsPage sdntData clubMap

getYoYoR :: Handler Html
getYoYoR = defaultLayout $ do
        pageTheme
        yoyoPage

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
                caesarSubmitSuccess sub

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
        pageTheme
        homePage

main :: IO ()
main = runStderrLoggingT $ withSqlitePool "SdntDB.sqlite3" openConnectionCount $ \pool -> liftIO $ do
    runResourceT $ runSqlPool (runMigration migrateAll) pool
    res <- static "Resources/"
    warp 80 TS {connPool = pool, src = res}
