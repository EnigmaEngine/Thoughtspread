module TS.App where
--import TS.Utils
import Database.Persist
import Database.Persist.TH
import Database.Persist.Sqlite
import Data.Text (Text, pack, unpack)
import Yesod.Static
import Yesod

--Main Application Type
data TS = TS {src :: Static, connPool :: ConnectionPool}

--Routing
staticFiles "Resources/"

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/caesar CaesarR GET
/caesar/result CResultR POST
/praDB/ PRADBR GET POST
/praDB/praClubs PRACR GET POST
/praDB/praClubs/results PRACRR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

--Constants
openConnectionCount = 4 :: Int

--Data Types
--Add admin password hash to DB
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Award
    title Text
    blurb Text
    deriving Show Read Eq
Club
    name Text
    minSize Int
    maxSize Int
    deriving Show Read Eq
Peak
    name Text
    teacher Text
    deriving Show Read Eq
Student
    name Text
    grade Int
    peak Peak
    choices [Club]
    club Club
    nominations [Award]
    awards [Award]
    hours Int
    deriving Show Read
|]

type Result = ([(Text,[Student])], [Student])

type ClubMap = [(Text, (Int,Int))]

data CSubmission = CSubmission {operation :: Bool, msg :: Text, key :: Int}

data ClubFStudent = ClubFStudent { sN  :: Text, sG  :: Int, sC1 :: Text, sC2 :: Text, sC3 :: Text}

--Instances
instance FromJSON Club where
    parseJSON (Object v) = Club <$> v .: "name" <*> v .: "minSize" <*> v .: "maxSize"
    parseJSON invalid = fail $ "Failed to parse: " ++ show invalid

instance ToJSON ClubFStudent where
    toJSON (ClubFStudent n g f s t) = object ["name" .= n, "grade" .= g, "1st" .= f, "2nd" .= s, "3rd" .= t]

instance FromJSON ClubFStudent where
    parseJSON (Object v) = ClubFStudent <$> v .: "name" <*> v .: "grade" <*> v .: "1st" <*> v .: "2nd" <*> v .: "3rd"
    parseJSON invalid = fail $ "Failed to parse: " ++ show invalid

instance Eq Student where
    (==) sdnt1 sdnt2 = studentName sdnt1 == studentName sdnt2

instance Yesod TS

instance RenderMessage TS FormMessage where
    renderMessage _ _ = defaultFormMessage

instance YesodPersist TS where
    type YesodPersistBackend TS = SqlBackend
    runDB action = do
        TS {..} <- getYesod
        runSqlPool action connPool
