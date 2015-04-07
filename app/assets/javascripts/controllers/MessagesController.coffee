
controllers = angular.module('controllers')


controllers.controller('MessagesCtrl', [ '$scope','$http', 
 ($scope, $http ) -> 
    $http(
         url: '/messages'
      ).success((data)->
        $scope.inbox =  data.messages )
    $scope.messages = []
    $scope.getMessages = (conversationID) ->
        $http.get( '/messages/' + conversationID ).success((data)-> $scope.messages[conversationID] =  data.messages)





])
      

