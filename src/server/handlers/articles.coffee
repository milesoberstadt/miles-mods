Handler = require 'provide-handler'
{ Articles } =  require '../models'
monk = require 'monk'

class ArticlesHandler
  all: (req, res, next) ->
    if req.query.url
      safe_url = req.query.url.replace(/([^a-zA-Z0-9\-])/, '')
      Articles.find_by_url(safe_url).then (article) ->
        res.json article
    else if req.query.id
      Articles.find_by_id(req.query.id).then (article) ->
        res.json article
    else
      Articles.all().then (articles) ->
        res.json articles

      res.json articles


module.exports = new ArticlesHandler
