module TS.Page.PRADB where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

--Add a random splash to each page load

dbHomePage :: WidgetT TS IO()
dbHomePage = [whamlet|
                <div .results>
                    <h1> Prospect Ridge Academy Student Database
                    <a href=@{PRADBAddR}>
                        <h4> Add Student
                    <a href=@{PRADBAwardR}>
                        <h4> Awards
                    <a href=@{PRADBSearchR}>
                        <h4> Search Students
                    <h4> Clubs Picker and Community Service Tracker (Coming Soon)
|]
