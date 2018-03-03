'use strict';
Handler = require 'provide-handler'
{ Articles } =  require '../models'
monk = require 'monk'

class ArticlesHandler
  all: (req, res, next) ->
    Articles.all().then (articles) ->
      res.json articles

module.exports = new ArticlesHandler
