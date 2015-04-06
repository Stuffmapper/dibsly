
controllers = angular.module('controllers')


controllers.controller('MessagesCtrl', [ '$scope','$http', 
 ($scope, $http ) -> 
     $http(
         url: '/messages'
      ).success((data)->
        console.log("hello dave")
        $scope.inbox =  data.messages )





])
      

