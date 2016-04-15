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
    , grades
    , fromStudent
    , updateStudentClubs
    , CSubmission(..)
    , opLst
    ) where
import Data.IORef as Export
import Text.Blaze as Export
import Data.Maybe as Export (fromJust)
import Data.Text as Export (Text, pack, unpack)
--import Data.List as Export
import Data.Char as Export
import Data.Yaml as Export
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

{-
fromStudent :: Student -> ClubFStudent
fromStudent s = ClubFStudent
    (studentName s)
    (studentGrade s)
    (studentChoices s !! 0)
    (studentChoices s !! 1)
    (studentChoices s !! 2)
-}

--updateStudentClubs :: ClubFStudent -> IO ()
--Blegh, work on this part. It needs to update a student's club choices.
updateStudentClubs (ClubFStudent cUpName cUpGrade cUpC1 cUpC2 cUpC3) sdnts =
    where sdnt = head $ filter (\s -> studentName s == cUpName) sdnts

clubsToMap :: [Club] -> ClubMap
clubsToMap = map (\(Club n mn mx) -> (n,(mn,mx)))

clubsToPairs :: ClubMap -> [(Text, Text)]
clubsToPairs clubLst = [(x,x) | x <- map fst clubLst]

grades :: [(Text, Int)]
grades = zip (map (pack . (++"th Grade") . show) [9..12]) [9..12]

opLst :: [(Text,Bool)]
opLst = [("Encrypt",True),("Decrypt",False)]
