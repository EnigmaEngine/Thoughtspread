module TS.Page.PRADBSearch where
import TS.Utils
import TS.App
import Yesod

--Actually write this code...

dbSearchForm :: Html -> MForm Handler (FormResult FSearch, Widget)
dbSearchForm = renderDivs $ FSearch <$> areq textField "Name Search: " Nothing

dbSearchSubmitSuccess :: [Student] -> WidgetT TS IO ()
dbSearchSubmitSuccess res = do
    [whamlet|
      <div .results>
          <h1> Search results
          $forall sdnt <- map concatName res
              <p>#{sdnt}
    |]

dbSearchFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
dbSearchFormWidget (widget, enctype) = do
    [whamlet|
      <div .formbox>
          <h1> Prospect Ridge Academy Student Database Search
          <form method=post action=@{PRADBSR} enctype=#{enctype}>
              ^{widget}
              <button>Submit
    |]
