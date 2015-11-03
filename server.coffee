Meteor.methods
  "_cloudinaryGetFileInfo": (fileId) ->
    check fileId, String

    @unblock()

    cloudName = Meteor.settings?.public?.CLOUDINARY_CLOUD_NAME
    apiKey = Meteor.settings?.public?.CLOUDINARY_API_KEY
    apiSecret = Meteor.settings?.CLOUDINARY_API_SECRET

    throw new Meteor.Error 'cloudinary-emptycloudname', 'cloud name is empty' unless cloudName
    throw new Meteor.Error 'cloudinary-emptyapikey', 'api key is empty' unless apiKey
    throw new Meteor.Error 'cloudinary-emptyapisecret', 'api secret is empty' unless apiSecret

    # TODO: Error handling for bad credentials
    try
      HTTP.get "https://api.cloudinary.com/v1_1/#{cloudName}/resources/image/upload/#{fileId}",
        auth: "#{apiKey}:#{apiSecret}"
    catch error
      return false
