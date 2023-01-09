# Week Menu
## Overview
A Flutter application to display the weekly menu of ISEC's canteen using a Docker server.

## Main screen

Shows the menu of current day, while swiping sideways users can navigate between the other week days.
It always fetches the data from Shared Preferences, except when pressing the refresh button, when it gets the data
from an API Get request to the server contained in docker.
Tapping this screen goes to the edit page.

## Edit screen

Users can update the menu for a day if they are located at ISEC. 
They can upload a photo of the menu, reset it to the original menu or simply submit a new meal.

## Plugins

This Flutter aplication uses the <i>camera</i>, <i>location</i> and <i>shared preferences</i> plugins.
