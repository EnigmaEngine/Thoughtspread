module TS.App where
import TS.Utils
import Yesod

staticFiles "Resources/"

data TS = TS {clubM :: IORef ClubMap, src :: Static}

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/praClubs PRAR GET
/praClubs/submitted PRASR POST
/praClubs/results PRARR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

instance Yesod TS

instance RenderMessage TS FormMessage where
    renderMessage _ _ = defaultFormMessage
