var factories;

factories = angular.module('factories');

factories.factory('AlertService', [
  '$http','$timeout', '$rootScope', function($http, $timeout, $rootScope) {
    var alerts;
    var checkingMessages = false;
    var firstCheck = false;
    var messages = [];
    alerts = {};
    return {
      clear: function() {
        return alerts = {};
      },
      unread: function(){
        return _.size(_.filter(messages, { 'is_read':false}))
      },
      add: function(type, text) {
        var alert, key;
        key = Math.floor(Math.random() * 1000);
        alert = {
          type: type,
          text: text,
          id: key
        };
        alerts[key] = alert;
        return $timeout((function() {
          try { delete alerts[key]; } catch(err){ }
        }), 4000);
      },
      remove: function(id) {
        return delete alerts[id];
      },
      get: function() {
        return alerts;
      },
      messages: function(){
        return messages;
      }, 
      markRead: function(conversation){

        _.forEach(_.filter(messages, function(message){ return message.conversation == conversation }), function(item) {item.is_read = true});
        $http.post('api/dibs/' + conversation + '/markread')
      },
      getMessages: function(){
        var that = this;
        if(!checkingMessages){
          checkingMessages = true;
          $timeout((function() {
            $http.get('/api/alerts')
            .then( function(data){
              //find the new unread alerts
              var newMessages = _.reject(data.data.alerts, function(alert){
                return _.find(messages, function(message){ return alert.id == message.id})
              })
              angular.forEach(newMessages, function (message) {
                messages.push(message);
                $rootScope.$broadcast('newMessage', message )
                if(firstCheck && ! message.is_read){
                  that.add('success', message.sender + ': ' + message.body)
                }
              });
              firstCheck = true;
            })
            .then( function(){ 
              checkingMessages = false;
              console.log(messages);
              that.getMessages() })
          }), 6000);
        }
      }
    };
  }
]);