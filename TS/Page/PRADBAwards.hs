module TS.Page.PRADBAwards where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...
awardForm :: [Awards] -> [Student] -> MonthYear -> MForm Handler (FormResult FStudent, Widget)
awardForm awards sdnts (year,month) =
    renderDivs $ FAward
    <$> areq (selectFieldList $ awardsToPairs awards) "Award: " Nothing
    <*> areq (radioFieldList $ zip (map concatName sdnts) sdnts) "Student: " Nothing
    <*> (unTextarea <$> areq textareaField "Blurb: " Nothing)
    <*> areq (selectFieldList months) "Month Awarded: " (Just month)
    <*> areq intField "Year Awarded: " (Just year)

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
