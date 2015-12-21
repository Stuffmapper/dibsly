var directives;

directives = angular.module('directives');

directives.directive('smdetails', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: ['$rootScope','$scope','$state', '$modal', 'UserService', 'AlertService', 'MarkerService',
    function($rootScope,$scope,$state,$modal, UserService, AlertService, MarkerService) {
      //add details specific functions here
      $scope.back = function(){
        $state.go($state.lastState || 'getStuff');
      }
      $scope.giveBack = function() {
        $scope.post.unDib()
        .then(function(marker){ 
          AlertService.add('success', "Item has been unDibsed"); 
          MarkerService.setMarker(marker)
        })
      }
      $scope.giveMe = function() {
          UserService.getCurrentUser()
          .then( 
            function(){
              return $scope.post.dib()
              .then(
                function(results) {
                  AlertService.add('success', "Dibbed this stuff");
                  return $scope.post.goToCurrentChat();
                },
                function(err) {
                  angular.forEach(err, function(value, key){
                    AlertService.add('danger', value);
                  });
                }
              )
            },
            function(){
              AlertService.add('warning', "Please Sign In to continue");
              $modal.open({ templateUrl: 'signIn.html', controller:'SignUpCtrl' })
            }
          );
        };
      $rootScope.$on( 'markerDeleted', function(event, args){
        if($state.$current.name == 'singlepost' ) {
          return $scope.post.id == args.postId  && $scope.back();
        }
      })
      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'details.html' 
  };
});

