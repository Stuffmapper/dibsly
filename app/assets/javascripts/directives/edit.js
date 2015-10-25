var directives;

directives = angular.module('directives');

directives.directive('edit', function() {
  return {
    restrict: 'E',
    scope: {
      post: '='
    },
    controller: [
      '$scope', 'UserService','AlertService', 'ImageService', 'MarkerService',
      function($scope, UserService, AlertService, ImageService, MarkerService ) {
        var images = {};
        $scope.categories = MarkerService.categories;
        $scope.editPost = function(){
          console.log($scope.post.latitude )

          //sends then new details
          return $scope.post.update()
          .then(function(){
            if($scope.post.imageChanged){
               return ImageService.upload($scope.editingImage , $scope.post.id, 'post' );
            }
          })
          .then( function(){ 
            console.log('thsi is so cool')
            return $scope.post.unSetEditState(); })
          .then(function() {
            return $scope.post.goToDetails() 
          })
          .then(function(){ 
            AlertService.add('success', "Your post has been updated");
          })
        };

        $scope.$on("fileSelected", function(event, args) {
          args.origin = args.location.split('/')[2]
          ImageService.createGroup(args)
          .then(function(group){
            $scope.post.imageChanged = true;
            $scope.editingImage = group.original;
            $scope.post.image_url = group.original;

          })
        });


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

