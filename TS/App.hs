module TS.App where
import Database.Persist
import Database.Persist.TH
import Database.Persist.Sqlite
import Data.Text (Text)
import Yesod.Static
import Yesod

--Main Application Type
data TS = TS {src :: Static, connPool :: ConnectionPool}

--Routing
staticFiles "Resources/"

mkYesodData "TS" [parseRoutes|
/ HomeR GET
/crazyYoYo YoYoR GET
/caesar CaesarR GET POST
/praDB PRADBR GET
/praDB/auth PRADBAuthR GET POST
/praDB/auth/update PRADBAuthUR GET POST
/praDB/student/#Int PRADBStudentR GET
/praDB/add PRADBAddR GET POST
/praDB/search PRADBSearchR GET POST
/praDB/award PRADBAwardR GET
/praDB/award/show PRADBShowAR GET POST
/praDB/award/add PRADBAwardSR GET POST
/praDB/award/add/#Text PRADBAAwardR GET POST
/praDB/praClubs PRADBClubR GET POST
/praDB/praClubs/results PRADBCResultR GET
/src ResourceR Static src
|]

--Constants
openConnectionCount = 4 :: Int
adminCookieTTL = 10 :: Int

--Type synonyms
type Name = (Text,Text)

type ClubMap = [(Text, (Int,Int))]

type MonthYear = (Integer,Int)

--Data Types

data Award = Award {title :: Text, blurb :: Text, month :: MonthYear}
    deriving (Show, Read, Eq)
derivePersistField "Award"

--Make admin pass an Admin ByteString hash rather than plain text.
--Possibly seperate out club choices into their own table. Along with nominations for awards.
--Restructure so that student contains only pertinent information. Just a club name rather than the Club datatype?
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Admin
    user Text
    pass Text
    deriving Show Read Eq
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

--Deprecated--------------------------------------------------------------------------------------
data ClubFStudent = ClubFStudent { sN  :: Text, sG  :: Int, sC1 :: Text, sC2 :: Text, sC3 :: Text}
--------------------------------------------------------------------------------------------------

data FStudent = FStudent Text Text Int Int Peak

data FAward = FAward Text Student Text Int Integer

--This is seriously stupid, get rid of it.
data FSearch = FSearch Text

data FMonth = FMonth Int Integer

--Instances
instance Yesod TS where
    makeSessionBackend _ = Just <$> defaultClientSessionBackend adminCookieTTL "client_session_key.aes"

instance Eq Student where
    (==) sdnt1 sdnt2 = studentName sdnt1 == studentName sdnt2

instance RenderMessage TS FormMessage where
    renderMessage _ _ = defaultFormMessage

instance YesodPersist TS where
    type YesodPersistBackend TS = SqlBackend
    runDB action = do
        TS {..} <- getYesod
        runSqlPool action connPool
