module TS.Page.PRADBAuth where
import TS.Logic
import TS.Utils
import TS.App
import Yesod

protectedPage expr = do
    admin <- lookupSession "admin"
    case admin of
        Nothing -> do
            setUltDestCurrent
            redirect PRADBAuthR
        Just admin -> expr

authPageForm :: [Admin] -> Html -> MForm Handler (FormResult Text, Widget)
authPageForm pass =
    renderDivs $ areq (checkBool (`elem` map adminPass pass) ("Incorrect password" :: Text) passwordField) "Administrator password: " Nothing

authPageFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
authPageFormWidget (widget, enctype) = do
    mmsg <- getMessage
    [whamlet|
      <div .formbox>
          <h1> Protected Page
          <h3> To view this page, please verify your admin status.
          <form method=post action=@{PRADBAuthR} enctype=#{enctype}>
              ^{widget}
              $maybe msg <- mmsg
                  <p class="alert">#{msg}
              <button>Login
    |]

authUpdateForm :: Html -> MForm Handler (FormResult Text, Widget)
authUpdateForm = renderDivs $ areq passwordField "New administrator password: " Nothing

authUpdateSubmitSuccess :: WidgetT TS IO ()
authUpdateSubmitSuccess = do
    [whamlet|
      <div .results>
          <h1> Prospect Ridge Academy Student Database
          <h3> Administrator password updated
    |]

authUpdateFormWidget :: (ToWidget TS w,ToMarkup e) => (w, e) -> WidgetT TS IO ()
authUpdateFormWidget (widget, enctype) = do
    mmsg <- getMessage
    [whamlet|
      <div .formbox>
          <h1> Update Password
          <h3> Please enter a new password.
          <form method=post action=@{PRADBAuthUR} enctype=#{enctype}>
              ^{widget}
              <button>Login
    |]
