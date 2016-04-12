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

--Data Types
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Student
    name Text
    grade Int
    peak Peak
    choices [Club]
    club Club
    nominations [(Int, Award)]
    awards [Award]
    hours Int
    deriving Show Read
Club
    name Text
    minSize Int
    maxSize Int
    deriving Show Read Eq
Peak
    name Text
    teacher Text
    deriving Show Read Eq
Award
    title Text
    blurb Text
    deriving Show Read Eq
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
    (==) (Student n1 g1 _) (Student n2 g2 _) = n1 == n2 && g1 ==g2

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
