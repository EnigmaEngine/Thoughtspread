#!/bin/sh
# Revise the elm build command to be more general.
elm make "Resources/Elm/YoYo.elm" --yes --output "Resources/yoyo.html"
stack build
