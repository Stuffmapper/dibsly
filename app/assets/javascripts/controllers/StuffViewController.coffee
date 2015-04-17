
controllers = angular.module('controllers')




controllers.controller('StuffViewCtrl', [ '$scope', '$http','$routeParams','$resource', 
 ($scope,$http,$routeParams,$resource) -> 
        $http(
            method: 'GET'
            url: '/posts/' + $routeParams.postId
          ).success((data)->
            console.log(data.post)
            $scope.post =  data.post  )

])
      

