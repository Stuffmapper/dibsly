(function() {
  var controllers;

  controllers = angular.module('controllers');

  controllers.controller('SignUpCtrl', [
    '$scope', '$modal', '$modalInstance', '$http', '$window', '$timeout', 'UserService', 'AlertService', function($scope, $modal, $modalInstance, $http, $window, $timeout, UserService, AlertService) {
      $scope.cancel = function() {
        $modalInstance.dismiss('cancel');
        return $location.path('/');
      };
      $scope.oaLogin = function(provider) {
        var fbauth;
        fbauth = "http://" + $window.location.host + '/auth/' + provider;
        return $window.location.href = fbauth;
      };
      $scope.showPolicy = function(policy) {
        return $modal.open({
          templateUrl: policy + '.html',
          controller: 'SignUpCtrl'
        });
      };
      $scope.signup = function() {
        var user;
        user = {
          first_name: $scope.first_name,
          last_name: $scope.last_name,
          username: $scope.username,
          email: $scope.email,
          password: $scope.password,
          password_confirmation: $scope.password_confirmation,
          phone_number: $scope.phone_number,
          anonymous: $scope.anonymous
        };
        return $http.post('/api/users', {
          user: user
        }).success(function() {
          $modalInstance.dismiss('cancel');
          $modal.open({
            templateUrl: 'welcome.html',
            controller: 'SignUpCtrl'
          });
          return $location.path('/');
        }).error(function(data) {
          var key, results, value;
          results = [];
          for (key in data) {
            value = data[key];
            results.push(AlertService.add('danger', key + ' ' + value));
          }
          return results;
        });
      };
      $scope.signin = function() {
        return UserService.login($scope.username, $scope.password, function(err, data) {
          if (err) {
            return AlertService.add('danger', "Wrong username or password");
          } else if (data.user) {
            if ($window.location.origin !== "http://" + $window.location.host) {
              $window.location.href = "http://" + $window.location.host;
              alert('hello ');
            }
            AlertService.add('success', 'You have been signed in');
            return $modalInstance.dismiss('cancel');
          } else {
            return alert(data.error);
          }
        });
      };
      $scope.fbsignin = function() {
        return UserService.login(function(err, data) {
          if (err) {
            return AlertService.add('danger', "Wrong username or password");
          } else if (data.user) {
            AlertService.add('success', 'You have been signed in.');
            return $modalInstance.dismiss('cancel');
          } else {
            return alert(data.error);
          }
        });
      };
      $scope.resetPW = function() {
        $modalInstance.dismiss('cancel');
        return $modal.open({
          templateUrl: 'resetPw.html',
          controller: 'SignUpCtrl'
        });
      };
      $scope.notSignUp = function() {
        return $modal.open({
          templateUrl: 'signUp.html',
          controller: 'SignUpCtrl'
        });
      };
      $scope.submitReset = function() {
        console.log($scope.email);
        return $http({
          url: '/api/password_resets',
          method: 'POST',
          params: {
            email: $scope.email
          }
        }).success(function() {
          AlertService.add('success', "Reset email sent");
          return $modalInstance.dismiss('cancel');
        }).error(function(data) {
          var key, results, value;
          results = [];
          for (key in data) {
            value = data[key];
            results.push(AlertService.add('danger', key + ' ' + value));
          }
          return results;
        });
      };
    }
  ]);

}).call(this);
