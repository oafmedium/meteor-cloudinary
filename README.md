# Cloudinary for Meteor
This package provides access to the powerful image transformation API of [Cloudinary](https://cloudinary.com) and upload capabilities via the official Node.js ([cloudinary/cloudinary_npm](https://github.com/cloudinary/cloudinary_npm)) and jQuery([cloudinary/cloudinary_js](https://github.com/cloudinary/cloudinary_js)) packages.

## Installation

Enter in your Meteor app directory:

```bash
$ meteor add oaf:cloudinary
```

## Authentication

Provide your Cloudinary credentials via [Meteor settings](http://docs.meteor.com/#/full/meteor_settings). You can find your Cloudinary authentication credentials in your [Cloudinary Management Console](https://cloudinary.com/console).

```JSON
{
  "public": {
    "CLOUDINARY_CLOUD_NAME": "<your cloud name>",
    "CLOUDINARY_API_KEY": "<your api key>"
  },
  "CLOUDINARY_API_SECRET": "<your api secret>"
}
```

## 

## License

This Meteor package is licensed under the MIT license.
