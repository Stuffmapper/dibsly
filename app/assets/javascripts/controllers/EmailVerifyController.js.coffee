
controllers = angular.module('controllers')




controllers.controller('EmailVerifyCtrl', [ '$http','$routeParams','$resource','AlertService', 
 ($http,$routeParams,$resource, AlertService ) -> 
   $http.post( '/users/email/' + $routeParams.userKey )
        .success((data)->
                AlertService.add('success', "You've verified your email!"))
        .error((data)->
                console.log(data)
                for key, value of data
                        AlertService.add('danger', key + ' ' + value )
        ) 

])
      

