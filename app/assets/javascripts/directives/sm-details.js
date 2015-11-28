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
    controller: ['$scope', '$modal', 'UserService', 'AlertService', 
    function($scope,$modal, UserService, AlertService) {
      //add details specific functions here
      $scope.giveMe = function() {
          UserService.getCurrentUser()
          .then( 
            function(){
              return $scope.post.dib()
              .then(
                function(results) {
                  return AlertService.add('success', "Dibbed your stuff");
                },
                function(err) {
                  angular.forEach(err, function(value, key){
                    AlertService.add('danger', value);
                  });
                }
              )
            },
            function(){
              AlertService.add('warn', "Please sign in to continue");
              $modal.open({ templateUrl: 'signIn.html', controller:'SignUpCtrl' })
            }
          );
        };
      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'details.html' 
  };
});

