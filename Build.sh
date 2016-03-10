#!/bin/sh
elm make "Resources/Elm/YoYo.elm" --yes --output "Resources/yoyo.html"
stack clean
stack build
