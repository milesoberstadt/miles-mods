Handler = require 'provide-handler'
{ KB } =  require '../models'
monk = require 'monk'

class KBHandler
  all: (req, res, next) ->
    if req.query.url
      safe_url = req.query.url.replace(/([^a-zA-Z0-9\-])/, '')
      KB.find_by_url(safe_url).then (article) ->
        res.json article
    else if req.query.id
      KB.find_by_id(req.query.id).then (article) ->
        res.json article
    else
      KB.all().then (articles) ->
        res.json articles

  update: (req, res, next) ->
    # New articles will have -1 as their _id, let's remove that and insert the record
    if req.params.id is "-1"
      delete req.body._id
      KB.insert(req.body).then (article) ->
        res.json article
    else
      KB.update(req.params.id, req.body).then (article) ->
        res.json article

  names: (req, res, next) ->
    KB.all_names().then (articles) ->
      res.json articles


module.exports = new KBHandler
