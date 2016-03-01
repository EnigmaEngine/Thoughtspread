module TS.App where
import TS.Utils
import Yesod

staticFiles "Resources/"

data TS = TS {src :: Static}

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/src ResourceR Static src
|]

instance Yesod TS
