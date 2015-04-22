
directives = angular.module('directives')

directives.directive('undib', ->
    restrict:'E'
    scope: { post: '=', mystuff: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService','MapsService', ($scope, $http,UserService,$modal,AlertService, MapsService )->

     $scope.giveBack = (post_id)->
        post_url = 'posts/' + post_id + '/undib'
        UserService.check( -> )
   
        if UserService.currentUser

	        $http.post(
	            post_url
	            ).success((data)->
                    delete mystuff[post_id]; AlertService.add('success', "unDibbed your stuff")
	            ).error (data) ->
	                for key, value of data
	                    AlertService.add('danger', key + ' ' + value )
        else
        	AlertService.add('danger', 'Please sign in to continue' )
        	$modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'
        ]
    replace:true,
    template:  '<button class= "btn-xs btn-default" ng-click=giveBack(post)>unDib</button>'   
)


