module TS.Page.PRADBSearch where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...

dbSearchForm :: Html -> MForm Handler (FormResult FSearch, Widget)
dbSearchForm = renderDivs $ FSearch <$> areq textField "Search for a student: " Nothing

dbSearchSubmitSuccess :: [Student] -> WidgetT TS IO ()
dbSearchSubmitSuccess res = do
    [whamlet|
      <div .results>
          <h1> Search results
          $forall (Student name num grade _ _ _ _ _) <- res
              <a href=@{PRADBStudentR num}>
                  <p>#{concatName name}, #{grade}th
    |]

dbSearchFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
dbSearchFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database Search
          <p> Enter the name of, or part of the name of, the student you are searching for.
          <form method=post action=@{PRADBSearchR} enctype=#{enctype}>
              ^{widget}
              <button>Search
    |]
