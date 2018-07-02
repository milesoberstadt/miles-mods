Handler = require 'provide-handler'
{ Articles, Images } =  require '../models'
monk = require 'monk'

class ArticlesHandler
  all: (req, res, next) ->
    new Promise((resolve, reject) ->
      if req.query.url
        safe_url = req.query.url.replace(/([^a-zA-Z0-9\-])/, '')
        resolve Articles.find_by_url safe_url
      else if req.query.id
        resolve Articles.find_by_id req.query.id
      else
        resolve Articles.all()
    ).then((articles) ->
      articles = [articles] if !Array.isArray articles

      if articles.length == 1
        res.json articles[0]
      else
        res.json articles
    )

  update: (req, res, next) ->
    # New articles will have -1 as their _id, let's remove that and insert the record
    new Promise((resolve, reject) ->
      # First, handle image uploading if we need to
      if req.body.previewIsBase64? and req.body.previewIsBase64 is true
        # Check to see if the image already exists, upload if it doesn't
        resolve Images.all(base64: req.body.previewImage)
      else
        resolve null
    ).then((result) ->
      # Second, either pass along the found result or store the image
      if result is null
        return Promise.resolve null
      else if !result.length # If the image isn't found, store it
        return Images.insert(base64: req.body.previewImage)
      else
        return Promise.resolve result[0]
    ).then((result) ->
      # Third, update the previewImage with the image ID
      if result? and result._id?
        req.body.previewImage = result._id.toString()
      return Promise.resolve req.body
    ).then((result) ->
      # Now we can actually save the article
      if req.params.id is "-1"
        delete result._id
        Articles.insert result
      else
        Articles.update req.params.id, result
    ).then((result) ->
      # Send the result back to the client!
      res.json result
    )

  names: (req, res, next) ->
    Articles.all_names().then (articles) ->
      res.json articles


module.exports = new ArticlesHandler
