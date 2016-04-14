module TS.App where
--import TS.Utils
import Database.Persist
import Database.Persist.TH
import Database.Persist.Sqlite
import Data.Text (Text, pack, unpack)
import Yesod.Static
import Yesod

staticFiles "Resources/"

--clubM :: IORef ClubMap
data TS = TS {src :: Static, connPool :: ConnectionPool}

--Constants
openConnectionCount = 4

--Type Synonyms
type Nominations = [(Int, Award)]

--Data Types
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
    nominations Nominations
    awards [Award]
    hours Int
    deriving Show Read
|]

type Result = ([(Text,[Student])], [Student])

type ClubMap = [(Text, (Int,Int))]

data CSubmission = CSubmission {operation :: Bool, msg :: Text, key :: Int}

data FStudent = FStudent { sN  :: Text, sG  :: Int, sC1 :: Text, sC2 :: Text, sC3 :: Text}

--Instances
instance FromJSON Club where
    parseJSON (Object v) = Club <$> v .: "name" <*> v .: "minSize" <*> v .: "maxSize"
    parseJSON invalid = fail $ "Failed to parse: " ++ show invalid

instance ToJSON FStudent where
    toJSON (FStudent n g f s t) = object ["name" .= n, "grade" .= g, "1st" .= f, "2nd" .= s, "3rd" .= t]

instance FromJSON FStudent where
    parseJSON (Object v) = FStudent <$> v .: "name" <*> v .: "grade" <*> v .: "1st" <*> v .: "2nd" <*> v .: "3rd"
    parseJSON invalid = fail $ "Failed to parse: " ++ show invalid

instance Eq Student where
    (==) sdnt1 sdnt2 = studentName sdnt1 == studentName sdnt2 && studentGrade sdnt1 == studentGrade sdnt2

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
