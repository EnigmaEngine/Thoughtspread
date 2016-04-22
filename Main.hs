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
import TS.Page.PRADB


--TODO:
--  1. Add award nomination functionality. Use a search field and submit button to narrow down the students in the listbox.
--  2. After the bare minimum nomination functionality is in place, pause and restructure the whole program to operate around
--the DB and the new types associated with it
--  3. Clean code, trim away fat, reduce the program to it's core, annihilate clutter. Comment every function and type with an
--explaination and purpose. If the function or type is unnecessary scrap it. If it would simplify the program to merge or
--seperate out functionality, do so.
--  4. Add admin password required for web-based management of the Student DB

mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/praDB/ PRADBR GET POST
/praDB/praClubs PRACR GET POST
/praDB/praClubs/results PRACRR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

getPRADBR :: Handler Html
getPRADBR = do
    rawPeaks <- runDB $ selectList [] []
    let peaks = fromEntities $ rawPeaks
    f <- generateFormPost (newStudentForm peaks)
    defaultLayout $ do
        praTheme
        dbFormWidget f

postPRADBR :: Handler Html
postPRADBR = do
    rawPeaks <- runDB $ selectList [] []
    let peaks = fromEntities $ rawPeaks
    ((result, widget), enctype) <- runFormPost (newStudentForm peaks)
    case result of
        FormSuccess fStudent -> do
            runDB $ insert (toStudent fStudent)
            defaultLayout $ do
                praTheme
                pradbSubmitSuccess

getPRACR :: Handler Html
getPRACR = do
    clubs <- runDB $ selectList [] []
    let clubMap = clubsToMap . fromEntities $ clubs
    f <- generateFormPost (studentClubForm clubMap)
    defaultLayout $ do
        praTheme
        clubFormWidget f

postPRACR :: Handler Html
postPRACR = do
    clubs <- runDB $ selectList [] []
    let clubMap = clubsToMap . fromEntities $ clubs
    ((result, widget), enctype) <- runFormPost (studentClubForm clubMap)
    case result of
        FormSuccess clubFStudent -> do
            --Add DB update here
            defaultLayout $ do
                praTheme
                pracSubmitSuccess

getPRACRR :: Handler Html
getPRACRR = do
    rawSdnts <- runDB $ selectList [] []
    clubs <- runDB $ selectList [] []
    let sdnts = fromEntities $ rawSdnts
        clubMap = clubsToMap . fromEntities $ clubs
    defaultLayout $ do
        praTheme
        resultsPage sdnts clubMap

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
    runResourceT $ runSqlPool (runMigrationSilent migrateAll) pool
    res <- static "Resources/"
    warp 80 TS {connPool = pool, src = res}
