var controllers;

controllers = angular.module('controllers');

controllers.controller('MessagesCtrl', [
  '$scope', 'AlertService', 'UserService', '$http', '$modal', '$modalInstance', function($scope, AlertService, UserService, $http, $modal, $modalInstance) {
    var self;
    $http({
      url: '/api/messages'
    }).success(function(data) {
      return $scope.inbox = data.messages;
    }).error(function() {
      return AlertService.add('danger', "Please login to continue");
    });
    $scope.messages = [];
    $scope.reply_message = {};
    self = this;
    $scope.currentUser = UserService.currentUser;
    $scope.getMessages = function(conversationID) {
      return $http.get('/api/messages/' + conversationID).success(function(data) {
        return $scope.messages[conversationID] = data.messages;
      });
    };
    $scope.postReply = function(conversationID) {
      return $http.post('/api/messages/' + conversationID, {
        message: $scope.reply_message[conversationID]
      }).success(function(data) {
        $scope.reply_message = {};
        return $scope.messages[conversationID] = data.messages;
      }).error(function() {
        return AlertService.add('danger', $scope.reply_message[conversationID].body);
      });
    };
    $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  }
]);
