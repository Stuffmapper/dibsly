
directives = angular.module('directives')

directives.directive('edit', ->
    restrict:'E'
    scope: { post: '=', stuff: '=', editing: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService','MapsService', ($scope, $http,UserService,$modal,AlertService, MapsService )->
     console.log("This is", $scope.stuff)
     $scope.close = ->
        $scope.editing = !$scope.editing

     $scope.updateStuff = ->
        console.log("update working")
        UserService.check(->)
        if UserService.currentUser
            formdata = new FormData();
            formdata.append('latitude', $scope.stuff.latitude)
            formdata.append('longitude', $scope.stuff.longitude)
            formdata.append('category', $scope.stuff.category)
            formdata.append('description', $scope.stuff.description)
            if $scope.files
                formdata.append('image', $scope.files[0]);
            $http.post( "/posts/" + $scope.stuff.id + "/update" , formdata, {
                headers: {'Content-Type': undefined}
                transformRequest: angular.identity
                }).success (data, status, headers, config) -> 
                    console.log('it worked')
                    AlertService.add('success', "Your post has been updated")
                    $scope.files = []
                .error (data) ->
                    for key, value of data
                        AlertService.add('danger', key + ' ' + value )
        else
            AlertService.add('danger', 'Please sign in to continue' )
            $modal.open
                templateUrl:'signIn.html',
                controller:'SignUpCtrl'
        ]
    replace:true,
    templateUrl:  'edit.html'   
)


