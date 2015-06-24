football-api-app
=================

Web app using the football-api.com API.

##Requirements

`npm` only.

##Setup

Clone the repo, and install with `npm install`.

##Lint and build

Running `npm run build` will lint and compile all `.coffee` and `.scss` files into `.js` and `.css` files,
and copy `index.html` to the root level.

In addition, if the `env` property in `package.json` is set to `production` (as opposed to `development`), the `.js`
and `.css` files will then be concatenated and minified, and the imports in the root level `index.html`
will be updated accordingly.

##Watch

Running `npm run watch` will run the appropriate `npm run build` tasks for the given environment whenever
any of the `.coffee`, `.scss`, `.html` or image files are changed.

##Start webserver

Start the web server with `npm start`.

The advised development workflow is to have `npm run watch` running in one terminal session, and `npm start`
running in another terminal session.

##Visit the webapp

Go to `http://localhost:8000`.

##Known bugs

- Graph and background image require a refresh to display correctly after a browser resize.
- Firefox: `README.md` is not imported from GitHub on the 'API' tab.