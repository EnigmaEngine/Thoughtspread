module TS.Utils
    ( module Export
    , Club(..)
    , ClubFStudent(..)
    , Student(..)
    , ClubMap
    , Result
    , clubsToMap
    , concatName
    , searchStudents
    , clubsToPairs
    , peaksToPairs
    , grades
    , fromEntities
    , toStudent
    , CSubmission(..)
    , opLst
    ) where
import Data.IORef as Export
import Text.Blaze as Export
import Data.Maybe as Export (fromJust)
import Data.Text as Export (Text, pack, unpack, append, breakOnAll)
import Data.Time.Calendar as Export
import Data.Time as Export
import Data.Char as Export
import Yesod.Static as Export
import Database.Persist as Export
import Database.Persist.TH as Export
import Database.Persist.Sqlite as Export
import Control.Monad.Trans.Resource as Export (runResourceT)
import Control.Monad.Logger as Export (runStderrLoggingT)

import qualified Data.Text as T
import TS.App

--Funtions
concatName :: Student -> Text
concatName = (\(fn,ln) -> fn `append` " " `append` ln) . studentName

searchStudents :: Text -> [Student] -> [Student]
searchStudents q sdnts = filter ((\x -> length (breakOnAll (T.toLower q) x) > 0) . T.toLower . concatName) sdnts

toStudent :: FStudent -> Student
toStudent (FStudent fname lname num grade peak) = Student (fname,lname) num grade peak [] Nothing [] 0

fromEntities :: [Entity a] -> [a]
fromEntities = map fromEntity
    where fromEntity (Entity _ x) = x

clubsToMap :: [Club] -> ClubMap
clubsToMap = map (\(Club n mn mx) -> (n,(mn,mx)))

clubsToPairs :: ClubMap -> [(Text, Text)]
clubsToPairs clubLst = [(x,x) | x <- map fst clubLst]

peaksToPairs :: [Peak] -> [(Text, Peak)]
peaksToPairs = map namePair
    where namePair p = ((peakName p) `append` " - " `append` (peakTeacher p),p)

grades :: [(Text, Int)]
grades = zip (map (pack . (++"th Grade") . show) [9..12]) [9..12]

awardsToPairs :: [Awards] -> [(Text,Text)]
awardsToPairs = map ((\x -> (x,x)) . awardsTitle)

months :: [(Text,Int)]
months = zip ["January","February","March","April","May","June","July","August","September","October","November","December"] [1..12]

opLst :: [(Text,Bool)]
opLst = [("Encrypt",True),("Decrypt",False)]
