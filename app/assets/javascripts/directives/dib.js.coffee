
directives = angular.module('directives')

directives.directive('dib', ->
    restrict:'E'
    scope: { post: '=' },
    controller:['$scope','$http','UserService','$modal','AlertService', ($scope, $http,UserService,$modal,AlertService )->

     $scope.giveMe = (post_id)->
        post_url = 'posts/' + post_id + '/dibs'
        UserService.check( (blank,data)->
          if data
            token = $("meta[name=\"csrf-token\"]").attr("content")
            $http.post( post_url,{
              headers: {'Content-Type': undefined,'X-CSRF-TOKEN':token}
              }).success(
                  (results)->
                    AlertService.add('success', "Dibbed your stuff")
                ).error(
                  (err)->
                    for key, value of err
                      AlertService.add('danger', key + ' ' + value ))
          else

          	AlertService.add('danger', 'Please sign in to continue' )
          	$modal.open
                  templateUrl:'signIn.html',
                  controller:'SignUpCtrl'
        )
    ]
    replace:true,
    template:  '<button class= "btn-xs btn-default" ng-click=giveMe(post)>Dib</button>'

)
