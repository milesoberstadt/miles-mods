path = require 'path'
express = require 'express'
session = require 'express-session'
passport = require 'passport'
Strategy = require('passport-local').Strategy
ensureLogin = require 'connect-ensure-login'
bodyParser = require 'body-parser'
helmet = require 'helmet'
handlers = require './handlers'

app = express()
app.use helmet()
app.use session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false})
app.use passport.initialize()
app.use passport.session()

api = express.Router()
api.use bodyParser.json()

# Setup local strategy for auth
passport.use new Strategy (username, password, cb) ->
  # Do the database comparison here, callback function expects
  console.log "Login attempt", username, password
  user =
    id: 1
    username: 'test'
    password: 'test2'
  if username is 'test' and password is 'test2'
    cb null, user
  else
    cb "User not found"

# If I understand serialize and deserialze, these functions write/read from the cookie
passport.serializeUser (user, cb) ->
  cb null, user.id
passport.deserializeUser (id, cb) ->
  # Get the user from the db, by id
  cb(null, {id: id})

login = express.Router()
login.use bodyParser.urlencoded {extended: true}
login.post '/',
  passport.authenticate('local', {failureRedirect: '/login'}),
  (req, res) ->
    res.redirect '/admin'
app.use '/login', login

# Auth needed routes
app.use '/admin', ensureLogin.ensureLoggedIn()

# path aliases for use in index.html
app.use '/assets', express.static path.join(__dirname, './assets')
app.use '/web', express.static path.join(__dirname, './web')

articles = express.Router()
articles.get '/', handlers.articles.all
articles.get '/:id', handlers.articles.get_with_id
api.use '/articles', articles

app.use '/api', api

# Send any route that express doesn't recognize to front end...
app.get '*', (req, res, next) ->
  res.sendFile path.join(__dirname, 'index.html')

port = process.env.PORT or 3000
app.listen port, () ->
  console.log "App running on #{port}..."
