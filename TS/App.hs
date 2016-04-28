module TS.App where
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
/praDB/search PRADBSR GET POST
/praDB/award PRADBAR GET POST
/praDB/praClubs PRACR GET POST
/praDB/praClubs/results PRACRR GET
/crazyYoYo YoYoR GET
/src ResourceR Static src
|]

--Constants
openConnectionCount = 4 :: Int

--Type synonyms
type Name = (Text,Text)

type ClubMap = [(Text, (Int,Int))]

type MonthYear = (Integer,Int)

--Data Types

data Award = Award Text Text MonthYear -- Title, Blurb, Year, Month
    deriving (Show, Read, Eq)
derivePersistField "Award"

--Add admin password hash to DB
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Awards
    title Text
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
    name Name
    number Int
    grade Int
    peak Peak
    choices [Club]
    club Club Maybe
    awards [Award]
    hours Int
    deriving Show Read
|]

type Result = ([(Text,[Student])], [Student])

data CSubmission = CSubmission {operation :: Bool, msg :: Text, key :: Int}

--Deprecated
data ClubFStudent = ClubFStudent { sN  :: Text, sG  :: Int, sC1 :: Text, sC2 :: Text, sC3 :: Text}

data FStudent = FStudent Text Text Int Int Peak

data FSearch = FSearch Text

--Instances
instance Yesod TS

instance Eq Student where
    (==) sdnt1 sdnt2 = studentName sdnt1 == studentName sdnt2

instance RenderMessage TS FormMessage where
    renderMessage _ _ = defaultFormMessage

instance YesodPersist TS where
    type YesodPersistBackend TS = SqlBackend
    runDB action = do
        TS {..} <- getYesod
        runSqlPool action connPool
