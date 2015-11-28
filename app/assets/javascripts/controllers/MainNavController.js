(function() {
  var controllers;

  controllers = angular.module('controllers');

  controllers.controller('MainNavCtrl', [
    '$scope', '$timeout', '$http', '$location', '$modal', 'UserService', 'AlertService',
     function($scope, $timeout, $http, $location, $modal, UserService, AlertService) {

      $scope.currentUser = function(){ return  UserService.currentUser() };
      $scope.showSignup = function() {
        return $modal.open({
          templateUrl: 'signUp.html',
          controller: 'SignUpCtrl'
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
    }
  ]);

}).call(this);
