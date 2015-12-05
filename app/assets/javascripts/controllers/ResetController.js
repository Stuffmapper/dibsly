var controllers;

controllers = angular.module('controllers');

controllers.controller('ResetCtrl', [
  '$scope','$state','$http', '$stateParams', 'AlertService',
  function($scope, $state, $http, $stateParams, AlertService) {
    $scope.cancel = function() {
      $state.go($state.lastState || 'getStuff' );
    };
    return $scope.changePassword = function() {
      var pw;
      pw = {
        password: $scope.password,
        password_confirmation: $scope.password_confirmation
      };
      if ($scope.password === !$scope.password_confirmation) {
        return AlertService.add('danger', "Passwords must match");
      } else if ($scope.password.length < 6) {
        return AlertService.add('danger', "Passwords must be longer than 6 characters");
      } else {
        return $http.patch('/api/password_resets/' + $stateParams.userKey, {
          user: pw
        }).success(function(data) {
          console.log(data.message);
          AlertService.add('success', "Password Changed");
          $state.go('getStuff' )
        }).error(function() {
          return AlertService.add('danger', "Something Went Wrong");
        });
      }
    };
  }
]);
