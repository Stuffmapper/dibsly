(function() {
    var controllers;

    controllers = angular.module('controllers');

    controllers.controller('MainNavCtrl', [
        '$scope', '$timeout', '$http', '$location', '$modal', 'UserService', 'AlertService',
        function($scope, $timeout, $http, $location, $modal, UserService, AlertService) {
            $scope.currentUser = function(){ return UserService.currentUser(); };
            $scope.alerts = function(){ return AlertService.unread(); };
            $scope.showLandfillTrackerInfo = function() {};
            $scope.showAbout = function(){
                $modal.open({
                    templateUrl:'splash.html',
                    controller: 'SignUpCtrl'
                });
            };
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
            $scope.callLandfillTracker = function() {
                $http.get('/api/landfillTracker')
                .then(function(data) {
                    $scope.landfillTrackerTemp = data.data.posts.length;
                    $timeout($scope.callLandfillTracker, 15000);
                });
            };
            $scope.updateLandfillTracker = function() {
                if($scope.landfillTracker < $scope.landfillTrackerTemp)
                    $scope.landfillTracker++;
                $timeout($scope.updateLandfillTracker, 500);
            };
            $scope.landfillTracker = '...';
            $scope.landfillTrackerTemp = 0;
            $http.get('/api/landfillTracker')
            .then(function(data) {
                $scope.landfillTracker = data.data.posts.length;
                $scope.landfillTrackerTemp = data.data.posts.length;
                $timeout($scope.callLandfillTracker, 10000);
                $timeout($scope.updateLandfillTracker, 500);
            });
        }
    ]);
}).call(this);
