controllers = angular.module('controllers', )
controllers.controller('MainNavCtrl',['$scope','$location','$modal', 'UserService',

    ($scope,$location,$modal,UserService)->

        $scope.UserService = UserService;
        $scope.$watchCollection('UserService',->
            $scope.currentUser = UserService.currentUser
        )
    



        $scope.showSignup = ->
            $modal.open
                templateUrl:'signUp.html',
                controller:'SignUpCtrl'

        $scope.showSignin = ->
            $modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'

        $scope.showLogout = ->
        	#do nothing
        	UserService.logout (err,data)->

      
    
])