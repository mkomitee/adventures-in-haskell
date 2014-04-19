import Control.Monad
import System.IO
import System.Process

main :: IO ()
main = do
    (_, Just hout, _, _) <-
        createProcess (proc "/sbin/dmesg" [])
           { cwd = Just "."
           , std_out = CreatePipe
           }

    processHandle hout

processHandle :: Handle -> IO ()
processHandle hout = do
  end <- hIsEOF hout
  unless end $ do
    line <- hGetLine hout
    processLine line
    processHandle hout


-- Here we're going to need to print the line as is unless it starts
-- with a timedelta. If it starts with a timedelta, figure out what
-- time it is by comparing it to the current timestamp (which can be
-- derived) from /proc/uptime.
processLine :: String -> IO ()
processLine line = putStrLn line
