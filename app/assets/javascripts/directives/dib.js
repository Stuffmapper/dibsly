var directives;

directives = angular.module('directives');

directives.directive('dib', function() {
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', '$http', 'UserService', '$modal', 'AlertService', function($scope, $http, UserService, $modal, AlertService) {
        return $scope.giveMe = function(post) {
          return post.dib()
          .then(
            function(results) {
              return AlertService.add('success', "Dibbed your stuff");
            },
            function(err) {
              var key, results1, value;
              results1 = [];
              for (key in err) {
                value = err[key];
                results1.push(AlertService.add('danger', key + ' ' + value));
              };
            }
          );
        };
      }
    ],
    replace: true,
    template: "<button class= 'dib-button dib-button-details' ng-click=giveMe(post)>I want this stuff! &gt;&gt;</button>"
  };
});

