var factories;

factories = angular.module('factories');

factories.factory('AlertService', [
  '$http','$timeout', function($http, $timeout) {
    var alerts;
    var checkingMessages = false;
    var messages = [];
    alerts = {};
    return {
      clear: function() {
        return alerts = {};
      },
      unread: function(){
        return _.size(_.filter(messages, { 'read':false}))
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
      getMessages: function(){
        var that = this;
        if(!checkingMessages){
          checkingMessages = true;
          $timeout((function() {
            $http.get('/api/alerts')
            .then( function(data){ 
              messages = data.data.alerts })
            .then( function(){ 
              checkingMessages = false;
              that.getMessages() })
          }), 6000);
        }
      }
    };
  }
]);