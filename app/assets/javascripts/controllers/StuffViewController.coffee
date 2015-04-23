
controllers = angular.module('controllers')




controllers.controller('StuffViewCtrl', [ '$scope', '$http','$routeParams','$resource', 'UserService', 
 ($scope,$http,$routeParams,$resource,UserService) ->
 	$scope.UserService = UserService
 	$scope.$watchCollection('UserService',->
    	$scope.currentUser = UserService.currentUser
    	)
 	$http(
        method: 'GET'
        url: '/posts/' + $routeParams.postId
      ).success((data)->
        console.log(data.post)
        $scope.post =  data.post  )

])
      

