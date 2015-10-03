var directives;

directives = angular.module('directives');

directives.directive('mystuffbtn', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color
  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', function($scope) {
        $scope.msg = function(post) {
          if(post.showWanted()) {
            if (post.noMessages()){
              $scope.color = 'green';
              return 'Wanted! (Waiting for message...)';
            } else { //I'm hoping the post.messages or will contain all the messages
              $scope.color = 'blue'
              return 'Messages <span class="fa-envelope"></span>';
            }
          } else {
            $scope.color = 'grey';
            return "Listed";
          }
        };
      }
    ],
    replace: true,
    link: linker,
    template: "<div class='col-lg-12 col-md-12 col-sm-12 mystuff-half-row'><button class='my-stuff-btn' ng-class='btn-color'>{{msg(post)}}</button></div>"
  };
});

