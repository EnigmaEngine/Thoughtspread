module TS.Utils
    ( module Export
    , Club(..)
    , ClubFStudent(..)
    , Student(..)
    , ClubMap
    , Result
    , failYaml
    , clubsToMap
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
import Data.Text as Export (Text, pack, unpack, append)
import Data.Char as Export
import Yesod.Static as Export
import Database.Persist as Export
import Database.Persist.TH as Export
import Database.Persist.Sqlite as Export
import Control.Monad.Trans.Resource as Export (runResourceT)
import Control.Monad.Logger as Export (runStderrLoggingT)

import Control.Exception
import TS.App

--Funtions
failYaml :: Either t [t1] -> [t1]
failYaml val = case val of
    Right x -> x
    Left _ -> []

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

opLst :: [(Text,Bool)]
opLst = [("Encrypt",True),("Decrypt",False)]
