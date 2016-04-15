module TS.Page.PRAC where
import TS.Utils
import TS.App
import Yesod

studentForm :: [(Text, (Int,Int))] -> Html -> MForm Handler (FormResult ClubFStudent, Widget)
studentForm cMap =
    renderDivs $ ClubFStudent
    <$> areq textField "Full Name: " Nothing
    <*> areq (selectFieldList grades) "Grade: " Nothing
    <*> areq (selectFieldList $ clubsToPairs cMap) "First Choice Club: " Nothing
    <*> areq (selectFieldList $ clubsToPairs cMap) "Second Choice Club: " Nothing
    <*> areq (selectFieldList $ clubsToPairs cMap) "Third Choice Club: " Nothing

pracSubmitSuccess :: WidgetT TS IO ()
pracSubmitSuccess = do
    [whamlet|
      <div .results>
          <h1> Prospect Ridge Academy Club Signup
          <h3> Form Submitted
          <p> Your submission has been recieved! You're done!
    |]

formWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
formWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Club Signup
          <form method=post action=@{PRASR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
