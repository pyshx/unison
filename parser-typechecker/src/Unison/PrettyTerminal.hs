module Unison.PrettyTerminal where

import Data.Char (isSpace)
import Data.List (dropWhileEnd)
import qualified System.Console.Terminal.Size as Terminal
import qualified Unison.Util.ColorText as CT
import Unison.Util.Less (less)
import qualified Unison.Util.Pretty as P

stripSurroundingBlanks :: String -> String
stripSurroundingBlanks s = unlines (dropWhile isBlank . dropWhileEnd isBlank $ lines s)
  where
    isBlank line = all isSpace line

-- like putPrettyLn' but prints a blank line before and after.
putPrettyLn :: P.Pretty CT.ColorText -> IO ()
putPrettyLn p | p == mempty = pure ()
putPrettyLn p = do
  width <- getAvailableWidth
  less . P.toANSI width $ P.border 2 p

putPrettyLnUnpaged :: P.Pretty CT.ColorText -> IO ()
putPrettyLnUnpaged p | p == mempty = pure ()
putPrettyLnUnpaged p = do
  width <- getAvailableWidth
  putStrLn . P.toANSI width $ P.border 2 p

putPrettyLn' :: P.Pretty CT.ColorText -> IO ()
putPrettyLn' p | p == mempty = pure ()
putPrettyLn' p = do
  width <- getAvailableWidth
  less . P.toANSI width $ p

clearCurrentLine :: IO ()
clearCurrentLine = do
  width <- getAvailableWidth
  putStr "\r"
  putStr . replicate width $ ' '
  putStr "\r"

putPretty' :: P.Pretty CT.ColorText -> IO ()
putPretty' p = do
  width <- getAvailableWidth
  putStr . P.toANSI width $ p

getAvailableWidth :: IO Int
getAvailableWidth =
  maybe 80 (\s -> 100 `min` Terminal.width s) <$> Terminal.size

putPrettyNonempty :: P.Pretty P.ColorText -> IO ()
putPrettyNonempty msg = do
  if msg == mempty then pure () else putPrettyLn msg
