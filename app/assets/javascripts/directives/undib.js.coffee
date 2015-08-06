
directives = angular.module('directives')

directives.directive('undib', ->
    restrict:'E'
    scope: { post: '=', mystuff: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService',
    ($scope, $http,UserService,$modal,AlertService)->

     $scope.giveBack = ()->
        post_url = '/api/posts/' + $scope.post.id + '/undib'
        UserService.check( (err, data )->
          if UserService.currentUser
  	        $http.post(
  	            post_url
  	            ).success((data)->
                    description = $scope.post.description
                    delete $scope.mystuff.dibs[$scope.post.id]
                    console.log($scope.mystuff.dibs)
                    localStorage.setItem('mystuff' + UserService.currentUser, JSON.stringify($scope.mystuff))
                    AlertService.add('success', "You've undibbed " + description );
  	            ).error (error ) ->
  	                for key, value of error
  	                    AlertService.add('danger', key + ' ' + value )
          else
            AlertService.add('danger', 'Please sign in to continue' )
            $modal.open
              templateUrl:'signIn.html',
              controller:'SignUpCtrl'
        )]
    replace:true,
    template:  '<button class= "btn-xs btn-default" ng-click=giveBack()>unDib</button>'
)
