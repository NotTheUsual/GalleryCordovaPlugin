var exec = require('cordova/exec');

exports.viewGallery = function(images, startIndex, success, error) {
  exec(success, error, 'GalleryPlugin', 'viewGallery', [images, startIndex]);
};
