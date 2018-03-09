monk = require 'monk'

class ArticlesModel
  db: monk process.env.MONGODB_URI
  collection: null

  constructor: () ->
    @collection = @db.get('users')

  find_by_id: (id) =>
    objID = monk.id(id)
    @collection.findOne({_id: objID})

  find_by_username: (username) =>
    @collection.findOne({username: username})

module.exports = new ArticlesModel
