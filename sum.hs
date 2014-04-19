import System.IO

main :: IO ()
main = process 0

process :: Double -> IO ()
process i = do
  end <- isEOF
  if end
    then print i
    else do line <- readLn
            process (i + line)
