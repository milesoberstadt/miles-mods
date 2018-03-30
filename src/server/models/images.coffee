monk = require 'monk'

class ImagesModel
  db: monk process.env.MONGODB_URI
  collection: null

  constructor: () ->
    @collection = @db.get('images')

  all: (searchObj) =>
    @collection.find(searchObj)

  insert: (insertObj) =>
    @collection.insert(insertObj)

  findOneByID: (id) =>
    objID = monk.id(id)
    @collection.findOne(objID)

module.exports = new ImagesModel
