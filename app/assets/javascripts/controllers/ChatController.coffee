
controllers = angular.module('controllers')


controllers.controller('ChatCtrl', [ '$scope','AlertService','UserService','$http','$modal','$modalInstance', '$routeParams',
 ($scope, AlertService, UserService,$http, $modal,$modalInstance, $routeParams ) -> 

    $http(
         url: '/chat/' + $routeParams.user, 
      ).success((data)->
        $scope.inbox =  data.messages
      ).error -> 
        AlertService.add('danger', "Please login to continue" )
    $scope.messages = []
    $scope.reply_message = {}
    self = this
    


    $scope.getMessages = (conversationID) ->
        $http.get( '/messages/' + conversationID ).success((data)-> $scope.messages[conversationID] =  data.messages)
    $scope.postReply = (conversationID) ->
        $http.post( '/messages/' + conversationID, message: $scope.reply_message[conversationID]
            ).success((data)->
                $scope.reply_message = {}
                $scope.messages[conversationID] =  data.messages
            ).error ->
                AlertService.add('danger', $scope.reply_message[conversationID].body )
    $scope.cancel = ->  
      $modalInstance.dismiss('cancel')



])
      

