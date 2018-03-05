monk = require 'monk'

class ArticlesModel
  db: monk process.env.MONGODB_URI

  all: () =>
    collection = @db.get('articles')
    collection.find()

  find_by_url: (url) =>
    collection = @db.get('articles')
    collection.findOne({url: url})

module.exports = new ArticlesModel
