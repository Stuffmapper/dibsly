(function() {
  var controllers;

  controllers = angular.module('controllers');

  controllers.controller('MainNavCtrl', [
    '$scope', '$timeout', '$http', '$location', '$modal', '$routeParams', 'UserService', 'AlertService', function($scope, $timeout, $http, $location, $modal, $routeParams, UserService, AlertService) {
      var updateMail;
      $scope.UserService = UserService;
      $scope.$watchCollection('UserService', function() {
        return $scope.currentUser = UserService.currentUser;
      });
      $scope.gotMail = false;
      $scope.toggle = false;
      updateMail = function() {
        if (UserService.currentUser) {
          $http.get('/api/messages/status').success(function(data) {
            if (data.newMessages > 0) {
              return $scope.gotMail = data.newMessages;
            } else {
              return $scope.gotMail = false;
            }
          }).error(function(err) {
            return console.log(err);
          });
        }
        return $timeout(updateMail, 200000);
      };
      updateMail();
      UserService.check()
      .then(function(){updateMail(); } )
      $scope.showSignup = function() {
        return $modal.open({
          templateUrl: 'signUp.html',
          controller: 'SignUpCtrl'
        });
      };
      $scope.showMessages = function() {
        return $modal.open({
          templateUrl: 'inbox.html',
          controller: 'MessagesCtrl'
        });
      };
      $scope.showSignin = function() {
        return $modal.open({
          templateUrl: 'signIn.html',
          controller: 'SignUpCtrl'
        });
      };
      $scope.showLogout = function() {
        return UserService.logout(function(err, data) {
          if (data) {
            return AlertService.add('success', 'You have been logged out.');
          } else {
            return AlertService.add('warning', 'Something went wrong');
          }
        });
      };
      if ($routeParams.modal === 'signup') {
        $scope.showSignin();
        return console.log('routed');
      }
    }
  ]);

}).call(this);
