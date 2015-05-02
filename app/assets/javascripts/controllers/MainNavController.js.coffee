controllers = angular.module('controllers', )
controllers.controller('MainNavCtrl',['$scope','$location','$modal','$routeParams','UserService', 'AlertService',

    ($scope,$location,$modal,$routeParams,UserService,AlertService)->

        $scope.UserService = UserService;
        $scope.$watchCollection('UserService',->
            $scope.currentUser = UserService.currentUser
        )
        
        $scope.toggle = false

    



        $scope.showSignup = ->
            $modal.open
                templateUrl:'signUp.html',
                controller:'SignUpCtrl'
                
        $scope.showMessages = ->
            $modal.open
                templateUrl:'inbox.html',
                controller:'MessagesCtrl'

        $scope.showSignin = ->
            $modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'

        $scope.showLogout = ->
        	#do nothing
        	UserService.logout (err,data)->
            AlertService.add('success','You have been logged out.')

        if $routeParams.modal == 'signup'
            $scope.showSignin()
            console.log('routed')

      
    
])