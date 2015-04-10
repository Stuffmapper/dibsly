
controllers = angular.module('controllers')


controllers.controller('MessagesCtrl', [ '$scope','$http','AlertService', 
 ($scope, $http, AlertService ) -> 
    $http(
         url: '/messages'
      ).success((data)->
        $scope.inbox =  data.messages )
    $scope.messages = []
    $scope.reply_message = {}
    $scope.getMessages = (conversationID) ->
        $http.get( '/messages/' + conversationID ).success((data)-> $scope.messages[conversationID] =  data.messages)
    $scope.postReply = (conversationID) ->
        $http.post( '/messages/' + conversationID, message: $scope.reply_message[conversationID]
            ).success((data)->
                $scope.reply_message = {}
                $scope.messages[conversationID] =  data.messages
            ).error ->
                AlertService.add('danger', $scope.reply_message[conversationID].body )



])
      

