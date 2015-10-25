var directives;

directives = angular.module('directives');

directives.directive('settings', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    controller: ['$scope', function($scope) {

      }
    ],
    transclude: true,
    replace: true,
    link: linker,
    templateUrl: 'misc/settings.html' 
  };
});

