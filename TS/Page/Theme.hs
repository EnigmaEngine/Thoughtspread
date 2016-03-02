module TS.Page.Theme where
import TS.Utils
import TS.App
import Yesod

pageTheme :: WidgetT TS IO ()
pageTheme = do
        setTitle "Thoughtspread"
        toWidgetHead
            [hamlet|<link rel="icon" type="image/x-icon" href="@{ResourceR icon_png}"/>|]
        toWidgetHead
            [lucius|
                body {
                    background-image: url(@{ResourceR bgPattern_png});
                }
                .mTheme {
                    margin: auto;
                    width: 60%;
                    text-align: center;
                    font-family: sans-serif;
                    background-color: rgba(85, 85, 85, 0.4);
                    border: 5px dashed white;
                    padding: 10px;
                }
                .formTheme {
                    line-height: 200%;
                    label, input, select, textarea {
                        margin: auto;
                        width: 60%;
                        display: block;
                    }
                    input, select {
                        width: 15%;
                    }
                    textarea {
                        resize: none;
                        height: 5em;
                    }
                }
            |]
