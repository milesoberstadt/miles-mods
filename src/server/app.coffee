path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
helmet = require 'helmet'
handlers = require './handlers'

app = express()
app.use helmet()
api = express.Router()
api.use bodyParser.json()

# path aliases for use in index.html
app.use '/assets', express.static path.join(__dirname, './assets')
app.use '/web', express.static path.join(__dirname, './web')

app.use '/api', api

# Send any route that express doesn't recognize to front end...
app.get '*', (req, res, next) ->
  res.sendFile path.join(__dirname, 'index.html')

port = process.env.PORT or 3000
app.listen port, () ->
  console.log "App running on #{port}..."
