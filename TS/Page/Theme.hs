module TS.Page.Theme where
import TS.Utils
import TS.App
import Yesod

pageTheme :: WidgetT App IO ()
pageTheme = do
        setTitle "Thoughtspread"
        toWidgetHead
            [hamlet|<link rel="icon" type="image/x-icon" href="@{ResourceR favicon_ico}"/>|]
        toWidgetHead
            [lucius|
                body {
                    background-image: url(@{ResourceR bgPattern_png});
                }
                .mTheme {
                    margin: auto;
                    width: 60%;
                    text-align: center;
                    font-family: "Comic Sans MS", sans-serif;
                    background-color: rgba(85, 85, 85, 0.4);
                    border: 10px dashed white;
                    padding: 10px;
                    p {
                        font-size: 95%;
                    }
                }
            |]
