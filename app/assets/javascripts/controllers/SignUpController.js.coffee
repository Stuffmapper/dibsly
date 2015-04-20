
controllers = angular.module('controllers')


controllers.controller('SignUpCtrl', [ '$scope','$modal', '$modalInstance', '$http', '$timeout','UserService','AlertService',
  ($scope, $modal, $modalInstance, $http, $timeout, UserService, AlertService ) -> 

  

    $scope.cancel = ->  
      $modalInstance.dismiss('cancel')


    $scope.showUserAgreement = ->
        $modal.open
            templateUrl:'userAgreement.html',
            controller:'SignUpCtrl'

    $scope.signup = ->
      user = {
          first_name: $scope.first_name
          last_name: $scope.last_name
          username: $scope.username
          email: $scope.email
          password: $scope.password
          password_confirmation: $scope.password_confirmation 
          phone_number: $scope.phone_number
          anonymous: $scope.anonymous
          }

      
      $http.post('/users', {user: user}  )
        .success -> 
          $modalInstance.dismiss('cancel')
        .error (data) ->
          for key, value of data
            
            AlertService.add('danger', key + ' ' + value )

    $scope.signin = ->
        UserService.login($scope.username, $scope.password,
            (err,data) ->
                if(err)
                    AlertService.add('danger', "Wrong username or password")
                else if(data.user)
                  AlertService.add('success','You have been signed in.')
                  $modalInstance.dismiss('cancel')
                else  
                  alert(data.error)   
          )
    $scope.resetPW = ->
      $modalInstance.dismiss('cancel')
      $modal.open
        templateUrl:'resetPw.html',
        controller: 'SignUpCtrl'

    $scope.submitReset = ->
      console.log($scope.email)
      $http(
           url: '/password_resets'
           method: 'POST'
           params: 
               email: $scope.email )
        .success -> 
          $modalInstance.dismiss('cancel')
        .error (data) ->
          for key, value of data
            
            AlertService.add('danger', key + ' ' + value )
])

