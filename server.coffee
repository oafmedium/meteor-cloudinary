Meteor.methods
  "_cloudinaryGetFileInfo": (fileId) ->
    # TODO: Error handling for bad credentials
    try
      HTTP.get "https://api.cloudinary.com/v1_1/#{Meteor.settings?.public?.CLOUDINARY_CLOUD_NAME}/resources/image/upload/#{fileId}",
        auth: "#{Meteor.settings?.public?.CLOUDINARY_API_KEY}:#{Meteor.settings?.CLOUDINARY_API_SECRET}"
    catch error
      return false
