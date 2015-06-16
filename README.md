football-api-app
=================

Web app using the football-api.com API

##Requirements

`node`, `bower` and `http-server`.

##Setup

Clone the repo, and install with `npm install` and then `bower install`.

##Lint and build

Running `grunt` will lint, compile and concatenate all `.coffee` files in `app/scripts/src`.

##Start webserver

Start the web server with `npm start` - this will also run the grunt tasks.

##Visit the webapp

Go to `http://localhost:8000/app/index.html`.

##Known bugs

- Graph and background image require a refresh to display correctly after a browser resize.
- Firefox: `README.md` is not imported from GitHub on the 'API' tab.