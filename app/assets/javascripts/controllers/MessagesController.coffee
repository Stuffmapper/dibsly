
controllers = angular.module('controllers')


controllers.controller('MessagesCtrl', [ '$scope','$http', 
 ($scope, $http ) -> 
    $http(
         url: '/messages'
      ).success((data)->
        $scope.inbox =  data.messages )
    $scope.messages = []
    $scope.reply_message = {}
    $scope.getMessages = (conversationID) ->
        $http.get( '/messages/' + conversationID ).success((data)-> $scope.messages[conversationID] =  data.messages)
    $scope.postReply = (conversationID) ->
        $http.post( '/messages/' + conversationID, message: $scope.reply_message 
            ).success((data)->
                $scope.reply_message = {}
                $scope.messages[conversationID] =  data.messages
                )



])
      

