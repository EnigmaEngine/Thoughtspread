module TS.Logic where
import TS.Utils

filterChars :: String -> String
filterChars = concat . intersperse " " . splitOnAny filtered
    where filtered = ['\NUL'..'\US']

splitOnAny :: Eq a => [a] -> [a] -> [[a]]
splitOnAny divLst lst = case break (`elem` divLst) lst of
    (b,[]) -> [b]
    (b,a)  -> splitOnAny divLst b ++ splitOnAny divLst (drop 1 a)

caesarShift sft = map ((drop (sft `mod` length ascii) (cycle ascii) !!) . subtract 32 . ord)
  where ascii = [' '..'~']
