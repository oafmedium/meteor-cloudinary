Package.describe({
  name: "oaf:cloudinary",
  version: "0.0.9",
  summary: "Cloudinary Package for Meteor",
  git: "https://github.com/oafmedium/meteor-cloudinary.git",
  documentation: "README.md"
});

Package.onUse(function(api) {
  api.versionsFrom("1.1.0.3");
  api.use(["coffeescript", "http", "reactive-var", "check"]);
  api.use(["ui","templating","spacebars", "jquery", "underscore", "linto:jquery-ui@1.11.2"], "client");
  api.addFiles("client.coffee", "client");
  api.addFiles("helpers.coffee", "client");
  api.addFiles("server.coffee", "server");
  api.addFiles([
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
