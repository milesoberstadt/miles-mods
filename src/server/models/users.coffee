monk = require 'monk'

class ArticlesModel
  db: monk process.env.MONGODB_URI

  find_by_id: (id) =>
    collection = @db.get('users')
    objID = monk.id(id)
    collection.findOne({_id: objID})

  find_by_username: (username) =>
    collection = @db.get('users')
    collection.findOne({username: username})

module.exports = new ArticlesModel
