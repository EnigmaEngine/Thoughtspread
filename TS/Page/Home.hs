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
                <a href=@{CaesarR}>
                    <h4> String Encryption
                <a href=@{YoYoR}>
                    <h4> Crazy YoYo
|]
