
controllers = angular.module('controllers')


controllers.controller('EmailVerifyCtrl', [ '$http','$window','$timeout','$routeParams',
'$resource','AlertService',
 ($http,$window,$timeout,$routeParams,$resource, AlertService ) ->
   $http.post( '/users/email/' + $routeParams.userKey )
        .success((data)->
          AlertService.add('success', "You've verified your email!")
          $timeout( (-> $window.location.href = "http://" + $window.location.host ),1000))
        .error((data)->
          for key, value of data
            AlertService.add('danger', key + ' ' + value )
          $timeout( (-> $window.location.href = "http://" + $window.location.host ),1000)
        )

])
