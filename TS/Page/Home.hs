module TS.Page.Home where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

homePage :: WidgetT TS IO()
homePage = [whamlet|
            <div .mTheme>
                <h1>Welcome to Thoughtspread!
                <h4>This website serves as the personal web portal of Brooks Rady.
                <a href=@{CaesarR}>String Encryption|]
