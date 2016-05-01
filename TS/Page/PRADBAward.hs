module TS.Page.PRADBAward where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...
awardForm :: [Awards] -> [Student] -> MonthYear -> Html -> MForm Handler (FormResult FAward, Widget)
awardForm awards sdnts (year,month) =
    renderDivs $ FAward
    <$> areq (selectFieldList $ awardsToPairs awards) "Award: " Nothing
    <*> areq (selectFieldList $ zip (map (concatName . studentName) sdnts) sdnts) "Student: " Nothing
    <*> (unTextarea <$> areq textareaField "Blurb: " Nothing)
    <*> areq (selectFieldList monthPairs) "Month Awarded: " (Just month)
    <*> areq intField "Year Awarded: " (Just year)

awardSubmitSuccess :: Text -> Text -> WidgetT TS IO ()
awardSubmitSuccess title sdnt = do
    [whamlet|
      <div .results>
          <h1> Prospect Ridge Academy Student Database
          <h3> Form Submitted
          <p> #{sdnt} has recieved the #{title} character award.
    |]

--Yes, these funtions are repetitive. Parameterize the "action" URL?

awardSFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
awardSFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <form method=post action=@{PRADBAwardSR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]

awardFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> Text -> WidgetT TS IO ()
awardFormWidget (widget, enctype) query = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <form method=post action=@{PRADBAwardR query} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
