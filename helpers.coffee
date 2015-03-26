Template.registerHelper 'CloudinaryFile', (fileId) ->
  Cloudinary.get fileId

Template.registerHelper 'CloudinaryUrl', (fileId, options) ->
  Cloudinary.get(fileId).url(options)
