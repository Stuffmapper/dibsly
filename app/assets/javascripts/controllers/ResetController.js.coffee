
controllers = angular.module('controllers')




controllers.controller('ResetCtrl', [ '$scope','$window', '$http','$routeParams','$resource','$modalInstance','AlertService',
 ($scope,$window,$http,$routeParams,$resource,$modalInstance, AlertService ) ->


        $scope.cancel = ->
        	$modalInstance.dismiss('cancel')
        $scope.changePassword = ->
          pw =
            password: $scope.password
            password_confirmation: $scope.password_confirmation
          if $scope.password ==! $scope.password_confirmation
            AlertService.add('danger', "Passwords must match")
          else if $scope.password.length < 6
            AlertService.add('danger', "Passwords must be longer than 6 characters")
          else
          	$http.patch( '/api/password_resets/' + $routeParams.user,
          		{user: pw})
              .success(
                (data)->
                  console.log(data.message)
                  AlertService.add('success', "Password Changed")
                  $window.location.href = "http://" + $window.location.host)
              .error(->
          			AlertService.add('danger', "Something Went Wrong")
          		)



])
