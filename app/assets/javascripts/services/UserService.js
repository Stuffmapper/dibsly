(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('UserService', [
    '$http', '$q', 'LocalService', function($http, $q, LocalService) {

      var self = this;
      self.checking = false;
      self.checkingQueue = [];
      return {
        login: function(username, password, callback) {
          //TODO switch to promises for consistency
          var that = this;
          loginData = {
            username: username,
            password: password
          };
          return $http.post('/api/sessions/create', loginData).success(function(data) {
            if (data && data.user) {
              that.currentUser = data.user;
              that.token = data.token;
              LocalService.set('sMToken', JSON.stringify(data));
            } else {
              console.log(data);
              LocalService.unset('sMToken');
              that.currentUser = false;
            }
            return callback(null, data);
          }).error(function(err) {
            console.log(err);
            that.currentUser = false;
            return callback(err);
          });
        },
        logout: function(callback) {
          //TODO switch to promises for consistency
          var that = this;
          localStorage.clear();
          //should this passed into LocalService?
          return $http.get('/api/log_out').success(function(data) {
            that.currentUser = false;
            return callback(null, data);
          }).error(function(err) {
            return callback(err);
          });
        },
        check: function(){
          var that = this;
          var rejectAll = function(){
            that.currentUser = false;
            while(self.checkingQueue.length > 0){
              var prom = self.checkingQueue.pop();
              prom.reject(that.currentUser)
            }
            self.checking = false;
          };
          var resolveAll = function(user){
            that.currentUser = user;
            while(self.checkingQueue.length > 0){
              var prom = self.checkingQueue.pop();
              prom.resolve(that.currentUser)
            }
            self.checking = false;
          };

          user = LocalService.getJSON('sMToken');
          var defer = $q.defer();
          self.checkingQueue.push(defer)
          if (!self.checking){
            self.checking = true;
            if (user) {
              $http.get('/api/auth/check?token=' + user.token)
              .success(function(data) {
                resolveAll(user.user);
              })
              .error(function(err) {
                rejectAll();
              });
            } else {
              rejectAll();
            }
          } 
          return defer.promise;
        },

        getCurrentUser: function(){
          var that = this;
          if( that.currentUser ){
            return $q.when(that.currentUser)
          } else { return that.check() }
        }
      };
    }
  ]);

}).call(this);
