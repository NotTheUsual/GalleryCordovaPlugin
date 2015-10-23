var exec = require('cordova/exec');

exports.viewGallery = function(success, error) {
  exec(success, error, 'GalleryPlugin', 'viewGallery');
};
