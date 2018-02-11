var api, app, bodyParser, express, handlers, helmet, path, port;

path = require('path');

express = require('express');

bodyParser = require('body-parser');

helmet = require('helmet');

handlers = require('./handlers');

app = express();

app.use(helmet());

api = express.Router();

api.use(bodyParser.json());

app.use('/assets', express["static"](path.join(__dirname, './assets')));

app.use('/web', express["static"](path.join(__dirname, './web')));

app.use('/api', api);

app.get('*', function(req, res, next) {
  return res.sendFile(path.join(__dirname, 'index.html'));
});

port = process.env.PORT || 3000;

app.listen(port, function() {
  return console.log("App running on " + port + "...");
});
