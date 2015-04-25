
directives = angular.module('directives')

directives.directive('dib', ->
    restrict:'E'
    scope: { post: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService','MapsService', ($scope, $http,UserService,$modal,AlertService, MapsService )->

     $scope.giveMe = (post_id)->
        post_url = 'posts/' + post_id + '/dibs'
        UserService.check( -> )
   
        if UserService.currentUser

	        $http.post(
	            post_url
	            ).success((data)->
                    delete MapsService.markers[post_id]; AlertService.add('success', "Dibbed your stuff")
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
    template:  '<button class= "btn-xs btn-default" ng-click=giveMe(post)>Dib</button>'   

)


