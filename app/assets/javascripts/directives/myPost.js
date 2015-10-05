var directives;

directives = angular.module('directives');

directives.directive('mypost', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color
  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: ['$scope', function($scope) {
      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'misc/myPost.html' 
  };
});

