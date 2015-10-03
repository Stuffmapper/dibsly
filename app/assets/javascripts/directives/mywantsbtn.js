var directives;

directives = angular.module('directives');

//maybe use jquery to add the envelope???????????

//need to link to function the changes the color

directives.directive('mywantsbtn', function() {
  console.log('do I print');
  function link(scope, element) {
    element.css('background-color', '#ff0000');
  }
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', function($scope) {
        $scope.msg = function(post) {
          console.log(post);
          if (post.noMessages()){
            $scope.color = 'green';
            return 'Send a message! (20min remaining)';
          } else if (post.newMessage()){
            $scope.color = 'blue'
            return "New Messages";
          } else {
            $scope.color = 'grey';
            return "Messages";
          }
        };
      }
    ],
    replace: true,
    template: "<div class='col-lg-12 col-md-12 col-sm-12 mystuff-half-row'><button ng-class='color' class='my-stuff-btn' ng-class='btn-color'>{{msg(post)}}&#9993;</button></div>",
    link: link
  };
});

