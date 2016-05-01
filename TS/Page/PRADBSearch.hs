module TS.Page.PRADBSearch where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...

dbSearchForm :: Html -> MForm Handler (FormResult FSearch, Widget)
dbSearchForm = renderDivs $ FSearch <$> areq textField "Search Students: " Nothing

dbSearchSubmitSuccess :: [Student] -> WidgetT TS IO ()
dbSearchSubmitSuccess res = do
    [whamlet|
      <div .results>
          <h1> Search results
          $forall (Student name num grade _ _ _ _ _) <- res
              <p><a href=@{PRADBStudentR num}>#{concatName name}, #{grade}th
    |]

dbSearchFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
dbSearchFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database Search
          <form method=post action=@{PRADBSearchR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
