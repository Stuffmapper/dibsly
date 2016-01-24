var directives;

directives = angular.module('directives');

directives.directive('giveStuffTwo', [ function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    controller: 'GiveStuffCtrl',
    replace: true,
    link: linker,
    templateUrl: 'menu/givestuff.two.html' 
  };
}]);

