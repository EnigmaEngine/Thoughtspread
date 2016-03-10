module TS.Page.YoYo where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

--Improve Elm loading method. Find a way to embed the code. Link the the .elm here rather than the .js

yoyoPage :: WidgetT TS IO()
yoyoPage = sendFile "text/html" "Resources/yoyo.html"
