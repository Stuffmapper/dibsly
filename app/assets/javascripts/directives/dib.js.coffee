
directives = angular.module('directives')

directives.directive('dib', ->
    restrict:'E'
    scope: { post: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService', ($scope, $http,UserService,$modal,AlertService )->

     $scope.giveMe = (post_id)->
        post_url = '/api/posts/' + post_id + '/dibs'
        UserService.check( (err,data)->
          if data
            $http.post( post_url,{
              }).success(
                  (results)->
                    AlertService.add('success', "Dibbed your stuff"))
                .error(
                  (err)->
                    for key, value of err
                      AlertService.add('danger', key + ' ' + value ))
          if err
            AlertService.add('danger', 'Please sign in to continue' )
            $modal.open
              templateUrl:'signIn.html'
              controller:'SignUpCtrl'
        )
    ]
    replace:true,
    template:  '<button class= "btn-xs btn-default" ng-click=giveMe(post)>Dib</button>'

)
