
controllers = angular.module('controllers')




controllers.controller('ResetCtrl', [ '$scope', '$http','$routeParams','$resource','$modalInstance','AlertService', 
 ($scope,$http,$routeParams,$resource,$modalInstance, AlertService ) -> 


        $scope.cancel = ->
        	$modalInstance.dismiss('cancel')
        $scope.changePassword = ->
        	pw = { password: $scope.password,
        	password_confirmation: $scope.password_confirmation 
        	}
        	console.log($routeParams.user)
        	$http.patch( '/password_resets/' + $routeParams.user, 
        		{user: pw} 
        		).success((data)->
        			console.log(data.message)
        			AlertService.add('success', "Password Changed")
        			$scope.cancel()
        		).error(->
        			AlertService.add('danger', "Something Went Wrong")

        		)



])
      

