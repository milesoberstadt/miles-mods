Handler = require 'provide-handler'
{ Articles } =  require '../models'
monk = require 'monk'

class ArticlesHandler
  all: (req, res, next) ->
    Articles.all().then (articles) ->
      res.json articles

  get_with_id: (req, res, next) ->
    safe_id = req.params.id.replace(/([^a-zA-Z0-9\-])/, '')
    Articles.find_by_url(safe_id).then (article) ->
      res.json article

module.exports = new ArticlesHandler
