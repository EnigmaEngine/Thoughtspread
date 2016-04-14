#!/bin/sh
elm make "Resources/Elm/YoYo.elm" --yes --output "Resources/yoyo.html"
stack init --allow-different-user
stack setup --allow-different-user
stack build --allow-different-user
