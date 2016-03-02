module TS.Utils
    ( module Export
    , CSubmission(..)
    , opLst
    ) where
import Data.IORef as Export
import Text.Blaze as Export
import Data.Maybe as Export (fromJust)
import Data.Text as Export (Text, pack, unpack)
import Data.List as Export
import Data.Char as Export
import Yesod.Static as Export

data CSubmission = CSubmission {operation :: Bool, msg :: Text, key :: Int}

opLst :: [(Text,Bool)]
opLst = [("Encrypt",True),("Decrypt",False)]
