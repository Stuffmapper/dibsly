var directives;

directives = angular.module('directives');

directives.directive('smdetails', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: ['$scope', function($scope) {
      //add details specific functions here
      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'details.html' 
  };
});

