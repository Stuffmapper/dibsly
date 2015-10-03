var directives;

directives = angular.module('directives');

//maybe use jquery to add the envelope???????????

//need to link to function the changes the color

directives.directive('chat', function() {
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', function($scope) {
      var seed = 
        [
          {user: 'admin', message: 'The item has been dibbed by q'},
          {user:'q', message: 'Hey I can pick it up in an hour!'},
          {user:'Superbad', message: 'Great Ill try and be home by then'},
          {user: 'q', message: 'Just a loooooooooooooong message for tylings Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed viverra est vitae enim efficitur consectetur. Proin eget maximus mi. Proin iaculis risus orci, vitae volutpat leo sagittis vel. Praesent iaculis, nunc ut mattis hendrerit, eros nisi facilisis nunc, vitae hendrerit elit nibh nec dui. Aliquam ac imperdiet ipsum. Aliquam risus tortor, finibus sit amet tellus sit amet, tempus egestas enim. Integer nisl turpis, pulvinar vel tincidunt eget, egestas quis augue. In id turpis lacus. Suspendisse accumsan enim non enim dapibus, quis laoreet purus fermentum.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed viverra est vitae enim efficitur consectetur. Proin eget maximus mi. Proin iaculis risus orci, vitae volutpat leo sagittis vel. Praesent iaculis, nunc ut mattis hendrerit, eros nisi facilisis nunc, vitae hendrerit elit nibh nec dui. Aliquam ac imperdiet ipsum. Aliquam risus tortor, finibus sit amet tellus sit amet, tempus egestas enim. Integer nisl turpis, pulvinar vel tincidunt eget, egestas quis augue. In id turpis lacus. Suspendisse accumsan enim non enim dapibus, quis laoreet purus fermentum'},
        ]

      $scope.getSenderColor = function(messageSender, currentUser) {
        console.log('scope line 26 ', $scope)
        if (currentUser === messageSender) {
          return 'blue';
        } else if ('admin' === messageSender) {
          return 'grey';
        } else {
          return 'green';
        }
      }
      $scope.chat = seed;
      }
    ],
    replace: true,
    templateUrl: 'misc/chat.html' 
  };
});