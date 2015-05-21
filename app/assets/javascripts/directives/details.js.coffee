
directives = angular.module('directives')

directives.directive('details', ->
    restrict:'E'
    scope: { post: '=', stuff: '=', viewing: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService','MapsService', ($scope, $http,UserService,$modal,AlertService, MapsService )->
     $scope.close = ->
        $scope.viewing = !$scope.viewing
        ]
    replace:true,
    templateUrl:  'post.html'   
)


