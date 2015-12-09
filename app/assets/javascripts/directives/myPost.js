var directives;

directives = angular.module('directives');

directives.directive('mypost', function() {
  var linker = function(scope, element, attrs) {
    //some jquery on element to change btn color

  }
  return {
    restrict: 'E',
    scope: {
      post: '=',
      chat: '='
    },
    controller: ['$scope', function($scope) {
        $scope.zi = "settings-standard"
        $scope.top = function(){
          $scope.zi = $scope.zi == "settings-top" ? "settings-standard" : "settings-top"
        };
        $scope.msg = function()  {  
          var rval;
          switch($scope.post.getState()) {
            case ('permaWant' || 'permaDibPost'):
                  rval = "Messages"
                  break;
              case 'waitingWant':
                  rval = "Send a message! (" + Math.floor((new Date($scope.post.dibbed_until ) - Date.now())/ 60000)  +" minutes remaining)"    ;
                  break;
             case 'waitingPost':
                  rval = "Dibbed! (waiting for messages )";
                  break;
              default:
                rval = "Listed";
          }
          return rval;
        };
        $scope.btnClass =  function() {
          var btncolor = $scope.post.showWanted()  ? 'green' : 'grey';
          return btncolor; 
        };
        
        $scope.btnAction = function(){
          $scope.chat = !$scope.chat;
        }
        //HELPERS
        var getState = function(post){
          if(post.permadib && post.isCurrentDibber){ return 'permaWant'} 
          else if( post.dibbed && post.isCurrentDibber){ return 'waitingWant'}
          else if( post.dibbed ){ return 'waitingPost'} 
          else { return 'unwantedPost'}
        }

      }
    ],
    replace: true,
    link: linker,
    templateUrl: 'misc/myPost.html' 
  };
});


// directives.directive('mywant', function() {
//   function link(scope, element) {
//   }
//   return {
//     restrict: 'E',
//     scope: {
//       post: '='
//     },
//     controller: [
//       '$scope', 'MessageService', function($scope, MessageService) {
//         var getColor = function(){

//         };
//         $scope.msg= 'Wanted';
//         $scope.btnClass = 'green';
//         $scope.btnAction = function(){
//           throw new Error('not implemented')
//         }


//       }
//     ],
//     replace: true,
//     templateUrl: 'misc/myWant.html',
//     link: link
//   };
// });

