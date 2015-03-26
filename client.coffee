###
 * Cloudinary Class
###

class CloudinaryConnection
  files: {}

  ###
   * Initialize CloudinaryConnection and get general Cloudinary functionality
   * @param  {String}               cloudName   Cloudinary cloudname like "example_cloud" (optional)
   * @param  {String}               apiKey      Public Cloudinary API key from management console (optional)
   * @param  {[type]}               apiSecret   Secret Cloudinary API key from management console (optional)
   * @return {CloudinaryConnection}
  ###
  constructor: ({@cloudName, @apiKey, @apiSecret} = {}) ->
    @cloudName ?= Meteor.settings?.public?.CLOUDINARY_CLOUD_NAME
    @apiKey ?= Meteor.settings?.public?.CLOUDINARY_API_KEY
    @apiSecret ?= Meteor.settings?.CLOUDINARY_API_SECRET

    console.log "Cloudinary: The cloud name has to be defined in Meteor settings." unless @cloudName
    console.log "Cloudinary: You need to provide authentication credentials in Meteor settings." unless @apiKey or @apiSecret

  ###
   * Get cached or new CloudinaryFile object
   * @param  {String}         fileId Ressource identifier from Cloudinary (like "sample.jpg")
   * @return {CloudinaryFile}        Returns a CloudinaryFile object for further transformations, etc.
  ###
  get: (fileId) ->
    # fileId = fileId.split('.')[0]
    new CloudinaryFile(fileId, this)


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

  constructor: (fileId, @connection = {}) ->
    # TODO: Handle names with dots
    fileNameParts = fileId.split('.')
    @_id = fileNameParts[0]

    @properties = @connection.files[@_id] ?= new ReactiveVar {}
    transformationDefaults =
      format: fileNameParts[fileNameParts.length - 1] if fileNameParts.length > 1
    @transformations = new ReactiveVar transformationDefaults or {}
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

  url: (options = {}) ->
    options = options.hash if options?.hash
    options = _.defaults options, @transformations.get(), cloud_name: @connection.cloudName
    $.cloudinary.url @_id, options


Cloudinary = new CloudinaryConnection()
