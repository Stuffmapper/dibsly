(function() {
  var factories;

  factories = angular.module('factories');

  factories.factory('UserService', [
    '$http', '$q', 'LocalService', function($http, $q, LocalService) {
      return {
        login: function(username, password, callback) {
          var self = this;
          loginData = {
            username: username,
            password: password
          };
          return $http.post('/api/sessions/create', loginData).success(function(data) {
            if (data && data.user) {
              self.currentUser = data.user;
              self.token = data.token;
              LocalService.set('sMToken', JSON.stringify(data));
            } else {
              console.log(data);
              LocalService.unset('sMToken');
              self.currentUser = false;
            }
            return callback(null, data);
          }).error(function(err) {
            console.log(err);
            self.currentUser = false;
            return callback(err);
          });
        },
        logout: function(callback) {
          var self = this;
          localStorage.clear();
          return $http.get('/api/log_out').success(function(data) {
            self.currentUser = false;
            return callback(null, data);
          }).error(function(err) {
            return callback(err);
          });
        },
        check: function(){
          var self = this;
          return $q( function(resolve, reject){
            var user;
            user = LocalService.getJSON('sMToken');
            if (user) {
              return $http.get('/api/auth/check?token=' + user.token)
              .success(
                function(data) {
                self.currentUser = user.user;
                resolve(data)
              }).error(function(err) {
                self.currentUser = false;
                reject(err);
              });
            } else {
              self.currentUser = false;
              reject('error');
            }
          });
        }
      };
    }
  ]);

}).call(this);
