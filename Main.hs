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
import TS.Page.PRADB
import TS.Page.PRADBClub
import TS.Page.PRADBCResult
import TS.Page.PRADBAdd
import TS.Page.PRADBSearch
import TS.Page.PRADBAward
import TS.Page.PRADBStudent

--TODO:
--  1. Add award nomination functionality. Use a search field and submit button to narrow down the students in the listbox.
--  2. After the bare minimum nomination functionality is in place, pause and restructure the whole program to operate around
--the DB and the new types associated with it
--  3. Clean code, trim away fat, reduce the program to it's core, annihilate clutter. Comment every function and type with an
--explaination and purpose. If the function or type is unnecessary scrap it. If it would simplify the program to merge or
--seperate out functionality, do so.
--  4. Add admin password required for web-based management of the Student DB

--Add /praDB/student show all students page.
mkYesodDispatch "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/praDB PRADBR GET
/praDB/student/#Int PRADBStudentR GET
/praDB/add PRADBAddR GET POST
/praDB/search PRADBSearchR GET POST
/praDB/award PRADBAwardSR GET POST
/praDB/award/#Text PRADBAwardR GET POST
/praDB/praClubs PRADBClubR GET POST
/praDB/praClubs/results PRADBCResultR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
        pageTheme
        homePage

getPRADBR :: Handler Html
getPRADBR = defaultLayout $ do
        praTheme
        dbHomePage

getPRADBStudentR :: Int -> Handler Html
getPRADBStudentR sn = do
    sdnt <- fromEntities <$> (runDB $ selectList [StudentNumber ==. sn] [])
    defaultLayout $ do
        praTheme
        studentPage sdnt

getPRADBAddR :: Handler Html
getPRADBAddR = do
    peaks <- fromEntities <$> (runDB $ selectList [] [])
    f <- generateFormPost $ newStudentForm peaks
    defaultLayout $ do
        praTheme
        dbFormWidget f

postPRADBAddR :: Handler Html
postPRADBAddR = do
    peaks <- fromEntities <$> (runDB $ selectList [] [])
    ((result, widget), enctype) <- runFormPost $ newStudentForm peaks
    case result of
        FormSuccess fStudent -> do
            runDB $ insert (toStudent fStudent)
            defaultLayout $ do
                praTheme
                pradbSubmitSuccess

getPRADBSearchR :: Handler Html
getPRADBSearchR = do
    f <- generateFormPost dbSearchForm
    defaultLayout $ do
        praTheme
        dbSearchFormWidget f

postPRADBSearchR :: Handler Html
postPRADBSearchR = do
    sdnts <- fromEntities <$> (runDB $ selectList [] [])
    ((result, widget), enctype) <- runFormPost dbSearchForm
    case result of
        FormSuccess (FSearch query) -> do
            defaultLayout $ do
                praTheme
                dbSearchSubmitSuccess (searchStudents query sdnts)

getPRADBAwardSR :: Handler Html
getPRADBAwardSR = do
    f <- generateFormPost dbSearchForm
    defaultLayout $ do
        praTheme
        awardSFormWidget f

postPRADBAwardSR :: Handler Html
postPRADBAwardSR = do
    ((result, widget), enctype) <- runFormPost dbSearchForm
    case result of
        FormSuccess (FSearch query) -> do
            defaultLayout $ do
                praTheme
                redirect (PRADBAwardR query)

getPRADBAwardR :: Text -> Handler Html
getPRADBAwardR query = do
    now <- liftIO getCurrentTime
    timezone <- liftIO getCurrentTimeZone
    let (y, m, _) = toGregorian $ localDay $ utcToLocalTime timezone now
    sdnts <- (searchStudents query . fromEntities) <$> (runDB $ selectList [] [])
    awards <- fromEntities <$> (runDB $ selectList [] [])
    f <- generateFormPost $ awardForm awards sdnts (y, m)
    defaultLayout $ do
        praTheme
        awardFormWidget f query

postPRADBAwardR :: Text -> Handler Html
postPRADBAwardR query = do
    now <- liftIO getCurrentTime
    timezone <- liftIO getCurrentTimeZone
    let (y, m, _) = toGregorian $ localDay $ utcToLocalTime timezone now
    sdnts <- (searchStudents query . fromEntities) <$> (runDB $ selectList [] [])
    awards <- fromEntities <$> (runDB $ selectList [] [])
    --Does runFormPost really need all of the form parameters again?
    ((result, widget), enctype) <- runFormPost $ awardForm awards sdnts (y, m)
    case result of
        FormSuccess (FAward title sdnt blurb month year) -> do
            let newStudentAwards = (Award title blurb (year,month)) : (studentAwards sdnt)
            runDB $ updateWhere [StudentNumber ==. (studentNumber sdnt)] [StudentAwards =. newStudentAwards]
            defaultLayout $ do
                praTheme
                awardSubmitSuccess title (concatName $ studentName sdnt)

getPRADBClubR :: Handler Html
getPRADBClubR = do
    clubMap <- (clubsToMap . fromEntities) <$> (runDB $ selectList [] [])
    f <- generateFormPost (studentClubForm clubMap)
    defaultLayout $ do
        praTheme
        clubFormWidget f

postPRADBClubR :: Handler Html
postPRADBClubR = do
    clubMap <- (clubsToMap . fromEntities) <$> (runDB $ selectList [] [])
    ((result, widget), enctype) <- runFormPost (studentClubForm clubMap)
    case result of
        FormSuccess clubFStudent -> do
            --Add DB update here
            defaultLayout $ do
                praTheme
                pracSubmitSuccess

getPRADBCResultR :: Handler Html
getPRADBCResultR = do
    sdnts <- fromEntities <$> (runDB $ selectList [] [])
    clubMap <- (clubsToMap . fromEntities) <$> (runDB $ selectList [] [])
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

main :: IO ()
main = runStderrLoggingT $ withSqlitePool "SdntDB.sqlite3" openConnectionCount $ \pool -> liftIO $ do
    runResourceT $ runSqlPool (runMigrationSilent migrateAll) pool
    res <- static "Resources/"
    warp 80 TS {connPool = pool, src = res}
