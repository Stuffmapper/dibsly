controllers = angular.module('controllers', )
controllers.controller('MainNavCtrl',['$scope','$timeout','$http','$location','$modal','$routeParams','UserService', 'AlertService',

    ($scope,$timeout,$http,$location,$modal,$routeParams,UserService,AlertService)->

        $scope.UserService = UserService;
        $scope.$watchCollection('UserService',->
            $scope.currentUser = UserService.currentUser
        )
        $scope.gotMail = false

        $scope.toggle = false

        updateMail = ->
          console.log("mail is being updated for", UserService.currentUser)
          if UserService.currentUser
            $http.get( '/messages/status')
            .success(
              (data)->
                if data.newMessages > 0
                  $scope.gotMail = data.newMessages
                else
                  $scope.gotMail = false )
            .error( (err)-> console.log(err))
          $timeout(updateMail,200000)
        updateMail()
        UserService.check((results, err)->
          updateMail()
        )
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
        	UserService.logout((err,data)->
            if data
              AlertService.add('success','You have been logged out.')
            else
              AlertService.add('warning', 'Something went wrong') )

        if $routeParams.modal == 'signup'
            $scope.showSignin()
            console.log('routed')


])
