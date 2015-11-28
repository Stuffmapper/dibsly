var controllers;

controllers = angular.module('controllers');

controllers.controller('EmailVerifyCtrl', [
  '$http', '$scope', '$window', '$timeout', '$stateParams', '$resource', 'AlertService', 
  function($http, $scope, $window, $timeout, $stateParams, $resource, AlertService) {
    $scope.message = 'Verifying your email';
    return $http.post('/api/users/email/' + $stateParams.userKey).success(function(data) {
      $scope.message = "Congrats! You've verified your email! Get started mapping your stuff or dib someone else's";
      return AlertService.add('success', "You've verified your email!");
    }).error(function(data) {
      var key, value;
      for (key in data) {
        value = data[key];
        AlertService.add('danger', key + ' ' + value);
      }
      return $scope.message = "Something went wrong and we couldn't verify your email";
    });
  }
]);