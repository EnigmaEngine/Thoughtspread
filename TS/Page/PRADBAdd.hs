module TS.Page.PRADBAdd where
import TS.Utils
import TS.App
import Yesod

newStudentForm :: [Peak] -> Html -> MForm Handler (FormResult FStudent, Widget)
newStudentForm peaks =
    renderDivs $ FStudent
    <$> areq textField "First Name: " Nothing
    <*> areq textField "Last Name: " Nothing
    <*> areq intField "Student Number: " Nothing
    <*> areq (selectFieldList grades) "Grade: " Nothing
    <*> areq (selectFieldList $ zip (map showPeak peaks) peaks) "Peak: " Nothing

pradbSubmitSuccess :: WidgetT TS IO ()
pradbSubmitSuccess = do
    [whamlet|
      <div .results>
          <h1> Prospect Ridge Academy Student Database
          <h3> Form Submitted
          <p> Your submission has been recieved and added to the database.
    |]

dbFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
dbFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <form method=post action=@{PRADBAddR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
