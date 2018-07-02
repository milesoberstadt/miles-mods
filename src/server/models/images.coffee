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

  insertOrGetExisting: (image) =>
    objIdRegex = new RegExp "^[0-9a-fA-F]{24}$"
    if image.match objIdRegex
      # This is an object id, just return that
    else
      # This should be base64, search for it in the db
    @collection.insert(insertObj)

  findOneByID: (id) =>
    objID = monk.id(id)
    @collection.findOne(objID)

module.exports = new ImagesModel
