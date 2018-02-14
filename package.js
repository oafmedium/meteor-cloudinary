Package.describe({
  name: "oaf:cloudinary",
  version: "0.1.0",
  summary: "Cloudinary Package for Meteor",
  git: "https://github.com/oafmedium/meteor-cloudinary.git",
  documentation: "README.md"
});

Package.onUse(function(api) {
  api.versionsFrom("1.6.1");
  api.use(["coffeescript@2.0.0", "http", "reactive-var", "check"]);
  api.use(["blaze@2.3.2", "templating@1.3.2", "spacebars@1.0.15", "jquery", "underscore"], "client");
  api.addFiles("client.coffee", "client");
  api.addFiles("helpers.coffee", "client");
  api.addFiles("server.coffee", "server");
  api.addFiles([
    'jquery-ui.js',
    "cloudinary_js/js/jquery.fileupload.js",
    "cloudinary_js/js/load-image.all.min.js",
    "cloudinary_js/js/canvas-to-blob.min.js",
    "cloudinary_js/js/jquery.fileupload-process.js",
    "cloudinary_js/js/jquery.fileupload-image.js",
    "cloudinary_js/js/jquery.fileupload-validate.js",
    "cloudinary_js/js/jquery.cloudinary.js"
  ], "client");
  api.export("Cloudinary");
});
