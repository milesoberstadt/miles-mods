monk = require 'monk'

class ArticlesModel
  db: monk process.env.MONGODB_URI
  collection: null

  constructor: () ->
    @collection = @db.get('articles')

  all: () =>
    @collection.find()

  all_names: () =>
    @collection.find({}, {title: 1})

  find_by_url: (url) =>
    @collection.findOne({url: url})

  find_by_id: (id) =>
    objID = monk.id(id)
    @collection.findOne({_id: objID})

  insert: (article) =>
    @collection.insert(article)

  update: (id, article) =>
    objID = monk.id(id)
    @collection.findOneAndUpdate({_id: objID}, article)

module.exports = new ArticlesModel
