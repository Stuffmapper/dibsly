(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('UserService', [
    'AlertService','$http', '$q', 'LocalService', 'MarkerService',
    function(AlertService,$http, $q, LocalService, MarkerService) {
      var self = this;
      self.checking = false;
      self.checkingQueue = [];
      return {
        currentUser: function(){
          return self.user;
        },
        login: function(username, password, callback) {
          //TODO switch to promises for consistency

          loginData = {
            username: username,
            password: password
          };
          return $http.post('/api/sessions/create', loginData)
          .success(function(data) {
            if (data && data.user) {
              self.user = data.user;
              self.token = data.token;
              LocalService.set('sMToken', JSON.stringify(data));
              AlertService.getMessages();
            } else {
              LocalService.unset('sMToken');
              self.user = false;
            }
            return callback(null, data);
          })
          .error(function(err) {
            self.user = false;
            return callback(err);
          });
        },
        logout: function(callback) {
          //TODO switch to promises for consistency
          //should this passed into LocalService?
          return $http.get('/api/log_out').success(function(data) {
            self.user = false;
            MarkerService.deleteAll();
            localStorage.clear();
            return callback(null, data);
          }).error(function(err) {
            return callback(err);
          });
        },
        check: function(){
          var rejectAll = function(){
            self.user = false;
            while(self.checkingQueue.length > 0){
              var prom = self.checkingQueue.pop();
              prom.reject(self.user);
            }
            self.checking = false;
          };
          var resolveAll = function(user){
            self.user = user;
            while(self.checkingQueue.length > 0){
              var prom = self.checkingQueue.pop();
              prom.resolve(self.user);
            }
            self.checking = false;
          };

          user = LocalService.getJSON('sMToken');
          var defer = $q.defer();
          self.checkingQueue.push(defer);
          if (!self.checking){
            self.checking = true;
            if (user) {
              $http.get('/api/auth/check?token=' + user.token)
              .success(function(data) {
                AlertService.getMessages();
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
          if( self.user ){
            return $q.when(self.user);
          } else { return that.check(); }
        }
      };
    }
  ]);

}).call(this);
