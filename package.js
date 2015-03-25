Package.describe({
  name: 'oaf:cloudinary',
  version: '0.0.1',
  summary: 'Cloudinary Package for Meteor',
  git: 'https://github.com/oafmedium/meteor-cloudinary.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.4.2');
  api.use('coffeescript');
  api.addFiles('cloudinary.coffee');
  api.addFiles('cloudinary_js/js/jquery.cloudinary.js', 'client');
  api.export('Cloudinary');
});
