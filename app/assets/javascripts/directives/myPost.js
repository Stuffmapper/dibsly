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
    controller: ['$http','$scope', function($http,$scope) {
        $http.get( 'api/dibs/' + $scope.post.currentDib.id + '/messages')
        .then(function(data){
          $scope.messages = data.data.dibs;
          console.log($scope.messages);
        });
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
                  rval = " Dibbed! (waiting for messages )";
                  break;
              default:
                rval = "Listed";
          }
          return rval;
        };
        $scope.btnClass =  function() {
          var rval;
          switch($scope.post.getState()) {
              case ('permaDibPost'):
                  rval = "blue";
                  break;
              case ('permaWant'):
                  rval = "grey";
                  break;
              case 'waitingWant':
                  rval = "green"
                  break;
             case 'waitingPost':
                  rval = "green";
                  break;
              default:
                rval = "grey";
          }
          return rval;
        };
        
        $scope.btnAction = function(){
          $scope.chat = !$scope.chat;
        }

        $scope.sendMessage = function() {
          return $http.post( 'api/dibs/' + $scope.post.currentDib.id + '/messages', {message: {body: $scope.newMessage}} )
          .success(function(data) {
            console.log("this is cool")
          }).error(function(err) {
            throw err;
          });
        }
        //HELPERS

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

