monk = require 'monk'

class ArticlesModel
  db: monk process.env.MONGODB_URI

  all: () =>
    collection = @db.get('articles')
    collection.find()

module.exports = new ArticlesModel
