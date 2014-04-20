import Control.Monad
import System.IO
import System.Process

main :: IO ()
main = do
  bootTime <- getBootTime
  hout <- dmesg
  processHandle bootTime hout


getBootTime :: IO Float
getBootTime = do
  contents <- readFile "/proc/uptime"
  return $ head $ map readFloat . words $ contents

readFloat :: String -> Float
readFloat = read

dmesg :: IO Handle
dmesg = do
    (_, Just hout, _, _) <-
        createProcess (proc "/sbin/dmesg" [])
           { cwd = Just "."
           , std_out = CreatePipe
           }

    return hout

processHandle :: Float -> Handle -> IO ()
processHandle bootTime hout = do
  end <- hIsEOF hout
  unless end $ do
    line <- hGetLine hout
    processLine bootTime line
    processHandle bootTime hout


-- Here we're going to need to print the line as is unless it starts
-- with a timedelta. If it starts with a timedelta, figure out what
-- time it is by adding it to bootTime and treating it like an epoch
processLine :: Float -> String -> IO ()
processLine bootTime line = putStrLn line


-- These libraries may prove necessary to compare the timestamps to
-- the current time and the uptime:
-- import Data.Time.Clock
-- import Data.Time.Clock.POSIX
