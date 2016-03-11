import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Time exposing (..)
import Debug
import Mouse
import Window
import Keyboard

fromJust x = case x of
    Just y -> y
    Nothing -> Debug.crash "WAT DIJA DO!?"

speedRange = (1,20)

delta = Signal.map inSeconds (fps 60)

type alias Pos = (Float,Float)

type alias Model = { current : Pos, target : Pos, rotation : Float, playerPath : List Pos, lastClick : Pos, going : Bool, speed : Float}

type alias Input = { click : Pos, shifted : Bool, enter : Bool, adjSpeed : Int}

init = Model (25,25) (25,25) 0.0 [] (0,0) False 5

modelState : Signal Model
modelState = Signal.foldp update init input

update : Input -> Model -> Model
update input {current,target,rotation,playerPath,lastClick,going,speed} =
  let
    (pcx,pcy) = current
    (ptx,pty) = target
    theta = atan2 (pty - pcy) (ptx - pcx)
    deltaX = (cos theta) * speed
    deltaY = (sin theta) * speed
    closeEnough (cx,cy) (tx,ty) = (abs (tx - cx) < speed) && (abs (ty - cy) < speed)
    newPos = if closeEnough current target then target else (pcx + deltaX, pcy + deltaY)
    tmpPlayerPath = if input.click /= lastClick then playerPath ++ [input.click] else playerPath
    moveTrigger = (not input.shifted) && (input.click /= lastClick || input.enter)
    stillGoing = not (List.isEmpty tmpPlayerPath)
    newGoing = if moveTrigger || (going && stillGoing) then True else False
    newTarget = if newGoing then fromJust (List.head tmpPlayerPath) else target
    newPlayerPath = if closeEnough newPos newTarget && newGoing then fromJust (List.tail tmpPlayerPath) else tmpPlayerPath
    clip n (mn,mx) = if n < mn then mn else if n > mx then mx else n
    newSpeed = clip (speed+((toFloat input.adjSpeed)/10)) speedRange
  in
    Model newPos newTarget (rotation + 0.02 * newSpeed) newPlayerPath input.click newGoing newSpeed

input : Signal Input
input = Signal.sampleOn delta <|
  Signal.map4 Input
    (Signal.map (\(x,y) -> (toFloat x, toFloat y)) (Signal.sampleOn Mouse.clicks Mouse.position))
    Keyboard.shift
    Keyboard.enter
    (Signal.map .y Keyboard.arrows)

view : (Int,Int) -> Model -> Element
view (w,h) player =
  let normalize (x,y) = (x - toFloat w / 2, toFloat h / 2 - y)
      fullPath = [player.current] ++ player.playerPath
      yoyo =
          square 20
            |> filled (hsl (player.rotation) 0.7 0.5)
            |> move (normalize player.current)
            |> rotate player.rotation
      background = rect (toFloat w) (toFloat h) |> filled black
      lines = traced (solid white) (path (List.map normalize fullPath))
      dots = List.map (\x -> circle 3 |> filled (rgb 255 100 0) |> move (normalize x)) fullPath
  in
    collage w h ([background,lines] ++ dots ++ [yoyo])

port title : String
port title = "Thoughtspread"

main : Signal Element
main = Signal.map2 view Window.dimensions modelState
