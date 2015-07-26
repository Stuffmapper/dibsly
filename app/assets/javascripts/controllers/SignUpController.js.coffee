
controllers = angular.module('controllers')


controllers.controller('SignUpCtrl', [ '$scope','$modal', '$modalInstance',
 '$http','$window', '$timeout','UserService','AlertService',
  ($scope, $modal, $modalInstance, $http,$window,$timeout, UserService, AlertService ) ->



    $scope.cancel = ->
      $modalInstance.dismiss('cancel')
      $location.path('/')
    $scope.oaLogin = (provider)->
      fbauth  = "http://" + $window.location.host + '/auth/' + provider
      $window.location.href = fbauth


    $scope.showPolicy = (policy)->
        $modal.open
            templateUrl: policy + '.html',
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


      $http.post('/api/users', {user: user}  )
        .success ->
          $modalInstance.dismiss('cancel')
          $modal.open
              templateUrl: 'welcome.html',
              controller:'SignUpCtrl'
          $location.path('/')
        .error (data) ->
          for key, value of data

            AlertService.add('danger', key + ' ' + value )

    $scope.signin = ->
        UserService.login($scope.username, $scope.password,
            (err,data) ->
                if(err)
                    AlertService.add('danger', "Wrong username or password")
                else if(data.user)
                  if $window.location.origin != "http://" + $window.location.host
                    $window.location.href = "http://" + $window.location.host
                    alert('hello ')
                  AlertService.add('success','You have been signed in')
                  $modalInstance.dismiss('cancel')
                else
                  alert(data.error)
          )
    $scope.fbsignin = ->
        UserService.login(
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

    $scope.notSignUp = ->
      $modal.open
        templateUrl:'signUp.html',
        controller: 'SignUpCtrl'

    $scope.submitReset = ->
      console.log($scope.email)
      $http(
           url: '/api/password_resets'
           method: 'POST'
           params:
               email: $scope.email )
        .success ->
          AlertService.add('success', "Reset email sent")
          $modalInstance.dismiss('cancel')
        .error (data) ->
          for key, value of data

            AlertService.add('danger', key + ' ' + value )
])
