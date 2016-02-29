module TS.App where
import TS.Utils
import Yesod

staticFiles "Resources/"

data TS = TS

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/src ResourceR Static resource
|]

instance Yesod App
