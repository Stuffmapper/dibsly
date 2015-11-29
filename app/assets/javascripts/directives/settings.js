var directives;

directives = angular.module('directives');

directives.directive('settings', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    controller: ['$scope', 'MarkerService', function($scope, MarkerService) {
        $scope.deletePost = function(id){
          var post = MarkerService.getMarker(id);
          post.remove()
          MarkerService['delete'](id);
        }

      }
    ],
    transclude: true,
    replace: true,
    link: linker,
    templateUrl: 'misc/settings.html' 
  };
});

