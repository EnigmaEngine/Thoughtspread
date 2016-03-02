module TS.App where
import TS.Utils
import Yesod

staticFiles "Resources/"

data TS = TS {src :: Static}

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/src ResourceR Static src
|]

instance Yesod TS

instance RenderMessage TS FormMessage where
    renderMessage _ _ = defaultFormMessage
