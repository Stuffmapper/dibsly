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
    controller: ['AlertService','$http','$scope', function(AlertService,$http,$scope) {
        if($scope.post.currentDib){
          $http.get( 'api/dibs/' + $scope.post.currentDib.id + '/messages')
          .then(function(data){
            $scope.messages = data.data.dibs;
          });
        }
        $scope.zi = "settings-standard"
        $scope.top = function(){
          $scope.zi = $scope.zi == "settings-top" ? "settings-standard" : "settings-top"
        };
        $scope.msg = function()  {  
          var rval;
          switch($scope.post.getState()) {
              case ('permaWant'):
                  rval = "Messages"
                  break;
              case ('permaDibPost'):
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
          var message = { created_at: Date.now(), sender: $scope.post.currentUser, body: $scope.newMessage, state:'sending' };
           $scope.newMessage = '';
          $scope.messages.push(message)
          return $http.post( 'api/dibs/' + $scope.post.currentDib.id + '/messages', {message: message } )
          .then(
            function(data) {
              $scope.messages = data.data.dibs
          },
          function(err){
            AlertService.add('warn', "Something went wrong try again")
            console.warn(err)
          })
        }
          $scope.autoExpand = function(e) {
        var element = typeof e === 'object' ? e.target : document.getElementById(e);
        var scrollHeight = element.scrollHeight -60; // replace 60 by the sum of padding-top and padding-bottom
        element.style.height =  scrollHeight + "px";    
    };
  
  function expand() {
    $scope.autoExpand('TextArea');
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

