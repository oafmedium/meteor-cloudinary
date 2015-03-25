###
 * Cloudinary Class
###

class CloudinaryConnection
  files: {}
  constructor: ({@cloudName, @apiKey, @apiSecret} = {}) ->
    @cloudName ?= Meteor.settings?.public?.CLOUDINARY_CLOUD_NAME
    @apiKey ?= Meteor.settings?.public?.CLOUDINARY_API_KEY
    @apiSecret ?= Meteor.settings?.CLOUDINARY_API_SECRET

    console.log "Created CloudinaryConnection: ", this

    unless @cloudName
      throw new Meteor.Error("cloudinary_cloud_name_not_provided",
        "Cloudinary: The cloud name has to be defined in Meteor settings.")

    unless @apiKey and @apiSecret
      throw new Meteor.Error("cloudinary_credentials_not_provided",
        "Cloudinary: You need to provide authentication credentials in Meteor settings.")

  get: (fileId) ->
    @files[fileId] ?= new CloudinaryFile(fileId, this)


###
 * Cloudinary File Class
###

class CloudinaryFile
  constructor: (@id, @connection = {}) ->
    console.log "Created CloudinaryFile: ", this

  getUrl: ->
    $.cloudinary.url @id,
      cloud_name: @connection.cloudName

Cloudinary = new CloudinaryConnection()
