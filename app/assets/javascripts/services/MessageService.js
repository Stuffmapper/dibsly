 factories = angular.module('factories')

 factories.factory('MessageService',[ '$q','$http', function($q, $http){

        return { 

          getAllMessage:function(){
            throw new Error('not implemented')
          },

          getUnreadCount:function(){
            throw new Error('not implemented')
          },

          getMessage:function(){
            throw new Error('not implemented')
          },

          sendMessage:function(){
            throw new Error('not implemented')
          },

       }
 }])
