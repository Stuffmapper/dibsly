var directives;

directives = angular.module('directives');

directives.directive('edit', function() {
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', 'UserService','AlertService', 'MarkerService', 
      function($scope, UserService, AlertService, MarkerService ) {
        var imageChanged = false;
        $scope.categories = MarkerService.categories;
        $scope.editPost = function(){
          console.log($scope.post.latitude )
          //throw new Error('not implemented yet')
          //this submits the post
          //two part
          
          //sends then new details
          return $scope.post.update()
          .then( function(){ $scope.post.unSetEditState() })

          //then 
          //sends the new image and

          //activates the alert serivice

          //changes the marker back to draggable

          //clears the listeners from the object

          //should remove the image object
        };
        $scope.changeImage = function(){
          imageChanged = true;
          //need to change to an on event

          //then attached to the post

          throw new Error('not implemented yet')
          //uses the imageservice to make a new image
          //should attach an image group
        },


        $scope.cancelEdit = function(){
          throw new Error('not implemented yet');

          //What the heck am I going to put here?
          //should change the 
        };
      }
    ],
    replace: true,
    templateUrl: 'menu/edit.html' };
});

