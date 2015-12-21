var directives;

directives = angular.module('directives');

directives.directive('giveStuffOne', function() {
  var linker = function(scope, element, attrs) {



  }
  return {
    restrict: 'E',
    controller: 'GiveStuffCtrl',
    replace: true,
    link: linker,
    templateUrl: 'menu/givestuff.one.html' 
  };
});

