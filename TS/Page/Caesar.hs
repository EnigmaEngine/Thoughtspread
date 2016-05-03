module TS.Page.Caesar where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

caesarForm :: Html -> MForm Handler (FormResult CSubmission, Widget)
caesarForm =
    renderDivs $ CSubmission
     <$> areq (selectFieldList opLst) "Would you like to encrypt or decrypt a message? " Nothing
     <*> (unTextarea <$> areq textareaField "Please enter a message: " Nothing)
     <*> areq intField "Please enter the message key: " Nothing

caesarSubmitSuccess :: CSubmission -> WidgetT TS IO ()
caesarSubmitSuccess (CSubmission op msg key) = do
    let res = pack $ caesarShift (if op then key else negate key) (filterChars $ unpack msg)
    [whamlet|
      <div .mTheme>
          <h1>Result
          <p>#{res}
    |]

caesarWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
caesarWidget (widget, enctype) = do
    [whamlet|
      <div .mTheme>
          <div .formTheme>
              <h1>Thoughtspread Caesar Encryption Widget
              <form method=post action=@{CaesarR} enctype=#{enctype}>
                  ^{widget}
                  <button>Submit
    |]
