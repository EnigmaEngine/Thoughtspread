module TS.Page.PRADBAwards where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...

awardForm :: Awards -> MonthYear -> Html -> MForm Handler (FormResult FStudent, Widget)
awardForm awards (year,month) =
    renderDivs $ FStudent
    <$> areq textField "First Name: " Nothing
    <*> areq textField "Last Name: " Nothing
    <*> areq intField "Student Number: " Nothing
    <*> areq (selectFieldList grades) "Grade: " Nothing
    <*> areq (selectFieldList $ peaksToPairs peaks) "Peak: " Nothing

awardSubmitSuccess :: WidgetT TS IO ()
awardSubmitSuccess = do
    [whamlet|
      <div .results>
          <h1> Prospect Ridge Academy Student Database
          <h3> Form Submitted
          <p> Your submission has been recieved and added to the database.
    |]

awardFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
awardFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <form method=post action=@{PRADBR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
