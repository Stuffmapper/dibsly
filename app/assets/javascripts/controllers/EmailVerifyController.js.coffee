
controllers = angular.module('controllers')


controllers.controller('EmailVerifyCtrl', [ '$http','$scope','$window','$timeout','$routeParams',
'$resource','AlertService',
 ($http,$scope,$window,$timeout,$routeParams,$resource, AlertService ) ->
   $scope.message = 'Verifying your email'
   $http.post( '/api/users/email/' + $routeParams.userKey )
        .success((data)->
          $scope.message = "Congrats! You've verified your email! Get started mapping your stuff or dib someone else's"
          AlertService.add('success', "You've verified your email!"))
        .error((data)->
          for key, value of data
            AlertService.add('danger', key + ' ' + value )
          $scope.message ="Something went wrong and we couldn't verify your email" )
          #$timeout( (->$window.location.href = "http://" + $window.location.host),1500))

])
