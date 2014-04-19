import Control.Monad
import System.IO

main :: IO ()
main = do
  end <- isEOF
  unless end $ do line <- getLine
                  putStrLn line
                  return main ()
