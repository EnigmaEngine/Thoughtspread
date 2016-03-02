module TS.Logic where
import TS.Utils

caesarShift sft = map ((drop (sft `mod` length ascii) (cycle ascii) !!) . subtract 32 . ord)
  where ascii = [' '..'~']
