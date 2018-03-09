path = require 'path'
express = require 'express'
session = require 'express-session'
passport = require 'passport'
Strategy = require('passport-local').Strategy
ensureLogin = require 'connect-ensure-login'
bcrypt = require 'bcrypt'
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
  # TODO: figure out a better error handling page
  # TODO: Add some logging with IPs and other stuff
  handlers.users.get_with_username username, (user) =>
    if !user
      return cb "User not found"
    # Check password hash
    bcrypt.compare password, user.password, (err, result) =>
      if !result
        return cb "User not found"
      cb null, user

# If I understand serialize and deserialze, these functions write/read from the cookie
passport.serializeUser (user, cb) ->
  cb null, user._id
passport.deserializeUser (id, cb) ->
  # Get the user from the db, by id
  handlers.users.get_with_id id, (user) =>
    if !user
      return cb null
    cb null, {id: user._id}

login = express.Router()
login.use bodyParser.urlencoded {extended: true}
login.post '/',
  passport.authenticate('local', {failureRedirect: '/login'}),
  (req, res) ->
    res.redirect '/admin'
# Uncomment this for a salted hash builder at /login/build
###
login.post '/build', (req, res, next) ->
  #res.json req.body.password
  bcrypt.hash req.body.password, 10, (err, hash) =>
    res.json hash
###
app.use '/login', login

# Auth needed routes
app.use '/admin', ensureLogin.ensureLoggedIn()

# path aliases for use in index.html
app.use '/assets', express.static path.join(__dirname, './assets')
app.use '/web', express.static path.join(__dirname, './web')

articles = express.Router()
articles.get '/', handlers.articles.all
articles.put '/:id', ensureLogin.ensureLoggedIn(), handlers.articles.update
articles.get '/names', handlers.articles.names
api.use '/articles', articles

app.use '/api', api

# Send any route that express doesn't recognize to front end...
app.get '*', (req, res, next) ->
  res.sendFile path.join(__dirname, 'index.html')

port = process.env.PORT or 3000
app.listen port, () ->
  console.log "App running on #{port}..."
