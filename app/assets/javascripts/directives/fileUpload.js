(function() {
  var directives;

  directives = angular.module('directives');

  directives.directive('fileUpload', ['$location', function($location) {
    return {
      scope: true,
      link: function(scope, el, attrs) {
        return el.bind('change', function(event) {
          var file, files, _i, _len, _results;
          files = event.target.files;
          if (event.target.files.length >= 1) {
            files = event.target.files;
          }
          _results = [];
          for (_i = 0, _len = files.length; _i < _len; _i++) {
            file = files[_i];
            _results.push(scope.$emit("fileSelected", {
              file: file,
              location: $location.path()
            }));
          }
          return _results;
        });
      }
    };
  }]);

}).call(this);
