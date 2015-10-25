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
        $scope.msg= function()  {  
          var msg = $scope.post.showWanted() ? 'Wanted' : 'Listed';
          return msg; 
        };
        $scope.btnClass =  function() {
          var btncolor = $scope.post.showWanted() ? 'green' : 'grey';
          return btncolor; 
        };
        
        $scope.btnAction = function(){
          throw new Error('not implemented')
        }
      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'misc/myPost.html' 
  };
});

