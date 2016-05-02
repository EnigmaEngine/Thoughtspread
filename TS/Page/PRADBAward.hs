module TS.Page.PRADBAward where
import TS.Utils
import TS.App
import Yesod

awardHomePage :: WidgetT TS IO()
awardHomePage = [whamlet|
            <div .results>
                <h1> Prospect Ridge Academy Student Database
                <a href=@{PRADBAwardSR}>
                    <h4> Award an Award
                <a href=@{PRADBShowAR}>
                    <h4> See Monthly Awards
|]

showAwardsForm :: MonthYear -> Html -> MForm Handler (FormResult FMonth, Widget)
showAwardsForm (year,month) =
    renderDivs $ FMonth
    <$> areq (selectFieldList monthPairs) "Month: " (Just month)
    <*> areq intField "Year: " (Just year)

showAwardsSubmitSuccess :: [Awards] -> [Student] -> MonthYear -> WidgetT TS IO ()
showAwardsSubmitSuccess awards sdnts date@(year,month) = do
    [whamlet|
      <div .results>
          <h1> Awards for #{monthToName month}, #{show year}
          $forall award <- map awardsTitle awards
              $with sdntLst <- monthlyAwards award date sdnts
                  $if null sdntLst
                  $else
                      <hr>
                      <h2> #{award}
                      $forall (Student name num _ peak _ _ awardLst _) <- sdntLst
                          <a href=@{PRADBStudentR num} class=hidden>
                              <h4>#{concatName name} - #{peakName peak}
                          <p><i>"#{blurb $ getAward award date awardLst}"</i>
|]

showAwardsFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
showAwardsFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <p> Enter the month and year of the awards you would like to view.
          <form method=post action=@{PRADBShowAR} enctype=#{enctype}>
              ^{widget}
              <button>Search
    |]

awardForm :: [Awards] -> [Student] -> MonthYear -> Html -> MForm Handler (FormResult FAward, Widget)
awardForm awards sdnts (year,month) =
    renderDivs $ FAward
    <$> areq (selectFieldList $ awardsToPairs awards) "Award: " Nothing
    <*> areq (selectFieldList $ studentsToPairs sdnts) "Student: " Nothing
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

awardFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> Text -> WidgetT TS IO ()
awardFormWidget (widget, enctype) query = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <form method=post action=@{PRADBAAwardR query} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]

awardSFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
awardSFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database
          <p> Enter the name of, or part of the name of, the student you would like to nominate.
          <form method=post action=@{PRADBAwardSR} enctype=#{enctype}>
              ^{widget}
              <button>Search
    |]
