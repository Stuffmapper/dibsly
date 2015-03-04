controllers = angular.module('controllers', )
controllers.controller('MainNavCtrl',['$scope','$location','$modal',
    ($scope,$location,$modal,UserService)->



        $scope.showSignup = ->
            $modal.open
                templateUrl:'signUp.html',
                controller:'SignUpCtrl'
        $scope.showSignin = ->
            $modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'
            
])