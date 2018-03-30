{Images} = require '../models'

class ImagesHandler
  get_image: (req, res, next) ->
    Images.findOneByID(req.params.id).then((result) ->
      if !result? or !result.base64?
        return res.json {error: 'Image not found'}
      # Turn the base64 into an image file
      imageData = result.base64.split(',')
      imageType = (imageData[0]).split(';')[0].slice(5)
      # Set the content type to the image type
      res.set('Content-Type', imageType)
      # Send the file!
      res.end imageData[1], 'base64'
    )

module.exports = new ImagesHandler
