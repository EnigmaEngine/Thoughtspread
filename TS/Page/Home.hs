module TS.Page.Home where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

--Add a random splash to each page load

homePage :: WidgetT TS IO()
homePage = [whamlet|
            <div .mTheme>
                <h1>Welcome to Thoughtspread!
                <h4><a href=@{CaesarR}>String Encryption
                <h4><a href=@{YoYoR}>Crazy YoYo|]
