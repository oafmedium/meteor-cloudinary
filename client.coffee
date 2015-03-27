###
 * Cloudinary Class
###

class CloudinaryConnection
  files: {}
  uploads: {}

  ###
   * Initialize CloudinaryConnection and get general Cloudinary functionality
   * @param  {String}               cloudName   Cloudinary cloudname like "example_cloud" (optional)
   * @param  {String}               apiKey      Public Cloudinary API key from management console (optional)
   * @param  {[type]}               apiSecret   Secret Cloudinary API key from management console (optional)
   * @return {CloudinaryConnection}
  ###
  constructor: ({@cloudName, @apiKey, @apiSecret, @preset} = {}) ->
    @cloudName  ?= Meteor.settings?.public?.CLOUDINARY_CLOUD_NAME
    @apiKey     ?= Meteor.settings?.public?.CLOUDINARY_API_KEY
    @apiSecret  ?= Meteor.settings?.CLOUDINARY_API_SECRET
    @preset     ?= Meteor.settings?.public?.CLOUDINARY_PRESET

    console.log "Cloudinary: The cloud name has to be defined in Meteor settings." unless @cloudName
    console.log "Cloudinary: You need to provide authentication credentials in Meteor settings." unless @apiKey or @apiSecret

  ###
   * Get cached or new CloudinaryFile object
   * @param  {String}         fileId Ressource identifier from Cloudinary (like "sample.jpg")
   * @return {CloudinaryFile}        Returns a CloudinaryFile object for further transformations, etc.
  ###
  get: (fileId, properties) ->
    # fileId = fileId.split('.')[0]
    new CloudinaryFile(fileId, this, properties)

  getUpload: (uploadId) ->
    @uploads[uploadId] ?= new ReactiveVar {}
    @uploads[uploadId].get()

  removeUpload: (uploadId, fileId) ->
    upload = @getUpload uploadId
    @uploads[uploadId].set _.extend upload, files: _.reject upload.files, (file) -> file._id is fileId

  removeUploads: (uploadId) ->
    @uploads[uploadId].set files: []

  upload: (selector, options = {}, callback) ->
    if @uploads[selector]
      $("[data-selector='#{selector}']").remove()
      $(selector).off 'click'

    events =
      fileuploadadd: (event, data) =>
        upload = @getUpload(selector)
        upload.previews ?= []
        upload.previews.push data.files[0]
        data.files[0]._id = Meteor.uuid()
        @uploads[selector].set upload
      fileuploadprogress: (event, data) =>
        upload = @getUpload(selector)
        upload.previews = _.map upload.previews, (preview) ->
          if data.files[0]._id is preview._id
            preview.progress =
              loaded: data.loaded
              total: data.total
          preview
        @uploads[selector].set upload
        callback? file
      fileuploaddone: (event, data) =>
        properties = data.response().result
        properties.name = data.files[0].name
        file = @get data.response().result.public_id, properties
        upload = @getUpload(selector)
        upload.files ?= []
        upload.files.push file
        upload.previews = _.reject upload.previews, (preview) -> data.files[0]._id is preview._id
        @uploads[selector].set upload
        callback? file
      # submit: @_handleUploadData
      # send: @_handleUploadData
      # change: @_handleUploadData
      # fail: @_handleUploadData
      # progress: @_handleUploadData
      # start: @_handleUploadData
      # stop: @_handleUploadData

    _.extend options,
      change: => input.unsigned_cloudinary_upload(@preset, cloud_name: @cloudName, options).bind events

    input = $('<input/>').attr({type: "file", name: "file"}).unsigned_cloudinary_upload(@preset, (cloud_name: @cloudName), options).bind events
    form = $('<form>').attr('data-selector', selector).hide().append input
    $('body').append form

    $(selector).on 'click', -> input.click()

    @getUpload(selector)


###
 * Cloudinary File Class
###

class CloudinaryFile
  defaults:
    angle: 0
    radius: 0
    quality: 100
    height: 0
    width: 0

  constructor: (fileId, @connection = {}, properties) ->
    # TODO: Handle names without format but with dots
    fileNameParts = fileId.split('.')

    transformationDefaults =
      format: fileNameParts[fileNameParts.length - 1] if fileNameParts.length > 1
    @transformations = new ReactiveVar transformationDefaults or {}
    fileNameParts.pop() if fileNameParts.length > 1
    @_id = fileNameParts.join('.')
    properties?.fetched = true
    @properties = @connection.files[@_id] ?= new ReactiveVar properties or {}

    return this

  property: (key, value) ->
    transformations = @transformations.get()
    value = undefined if value?.hash
    # TODO: Implement transformation chains
    if value
      transformations[key] = value
      @transformations.set transformations
      return this
    else if value = transformations[key]
      return value
    else
      @fetch() # if key in ['height', 'width', 'format', 'version']
      @properties.get()?[key] or @defaults[key]

  reset: ->
    @transformations.set {}
    @fetched = false # do not delete data for caching
    return this

  fetch: ->
    unless @properties.get().fetched or @properties.get().fetching
      @properties.set fetching: true
      Meteor.call "_cloudinaryGetFileInfo", @_id, (error, result) =>
        @properties.set _.extend fetched: true, result.data unless error
    return this

  # Transformations / Image Properties

  isImage: -> @property('resource_type') is 'image'

  height: (value) -> @property 'height', value

  width: (value) -> @property 'width', value

  format: (value) -> @property 'format', value

  crop: (value) -> @property 'crop', value

  gravity: (value) -> @property 'gravity', value

  quality: (value) -> @property 'quality', value

  radius: (value) -> @property 'radius', value

  angle: (value) -> @property 'angle', value

  version: (value) -> @property 'version', value

  opacity: (value) -> @property 'opacity', value

  # File Properties

  createdAt: (value) -> @property 'created_at', value

  resourceType: -> @property 'resource_type'

  name: -> @property 'name'

  url: (options = {}) ->
    options = options.hash if options?.hash
    defaults =
      resource_type: @resourceType()
      format: @format()
    options = _.defaults options, @transformations.get(), cloud_name: @connection.cloudName, defaults
    $.cloudinary.url @_id, options


Cloudinary = new CloudinaryConnection()
