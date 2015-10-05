var directives;

directives = angular.module('directives');

//maybe use jquery to add the envelope???????????

//need to link to function the changes the color

directives.directive('mywant', function() {
  function link(scope, element) {
  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', 'MessageService', function($scope, MessageService) {
        var getColor = function(){

        };
        $scope.msg= 'Wanted';
        $scope.btnClass = 'green';
        $scope.btnAction = function(){
          throw new Error('not implemented')
        }


      }
    ],
    replace: true,
    templateUrl: 'misc/myWant.html',
    link: link
  };
});

