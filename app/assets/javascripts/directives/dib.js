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
          console.log('dib directive give me scope', $scope)
          var post_url;
          post_url = '/api/posts/' + post.id + '/dibs';
          return UserService.check()
          .then(
            function(user){
              $http.post(post_url, {}).success(function(results) {
                return AlertService.add('success', "Dibbed your stuff");
              }).error(function(err) {
                console.log('error from post req')
                var key, results1, value;
                results1 = [];
                for (key in err) {
                  value = err[key];
                  results1.push(AlertService.add('danger', key + ' ' + value));
                }
                return results1;
              });
            },
            function(err){
              console.log('error dibbing: ', err)
              AlertService.add('danger', 'Please sign in to continue');
              $modal.open({
                templateUrl: 'signIn.html',
                controller: 'SignUpCtrl'
              });
            }
          );
        };
      }
    ],
    replace: true,
    template: "<button class= 'dib-button dib-button-details' ng-show='stuff.showDib()' ng-click=giveMe(post)>I want this stuff! &gt;&gt;</button>"
  };
});

