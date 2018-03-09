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

  update: (req, res, next) ->
    # New articles will have -1 as their _id, let's remove that and insert the record
    if req.params.id is -1
      delete req.body._id
      Articles.insert(req.body).then (article) ->
        res.json article
    else
      Articles.update(req.params.id, req.body).then (article) ->
        res.json article

  names: (req, res, next) ->
    Articles.all_names().then (articles) ->
      res.json articles


module.exports = new ArticlesHandler
